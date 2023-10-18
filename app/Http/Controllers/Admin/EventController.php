<?php

namespace App\Http\Controllers\Admin;

use App\Models\Event;
use App\Models\Player as PlayerModel;
use ArmSALArm\EloRating\Match;
use ArmSALArm\EloRating\Player;
use DB;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use TCG\Voyager\Events\BreadDataAdded;
use TCG\Voyager\Facades\Voyager;
use TCG\Voyager\Http\Controllers\Controller;
use Yajra\Datatables\Datatables;
use Carbon\Carbon;


class EventController extends VoyagerBaseController
{
    /**
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse|\Illuminate\Http\RedirectResponse
     * @throws \Illuminate\Auth\Access\AuthorizationException
     * @throws \Throwable
     */
    public function store(Request $request)
    {
        $slug = $this->getSlug($request);

        $dataType = Voyager::model('DataType')->where('slug', '=', $slug)->first();

        // Check permission
        $this->authorize('add', app($dataType->model_name));

        // Validate fields with ajax
        $val = $this->validateBread($request->all(), $dataType->addRows);

        if ($val->fails()) {
            return response()->json(['errors' => $val->messages()]);
        }

        if (!$request->has('_validate')) {

            $player1Model = PlayerModel::find($request->get('player_1'));
            $player2Model = PlayerModel::find($request->get('player_2'));
            $player1 = new Player($player1Model);
            $player2 = new Player($player2Model);

            $match = new Match($player1, $player2);

            $match->setResult($request->get('result'))
                ->calculate();

            $data = DB::transaction(function() use ($request, $match, $player1Model, $player2Model){
                $event = Event::create([
                    'result' => $request->get('result'),
                    'trn_id' => $request->get('tournament'),
//                    'slug' => $request->get('slug'),
                ]);

                $event->players()->create([
                    'p_id' => $player1Model->id,
                    'result' => $event->getPlayer1ResultByEvent(),
                    'shift' => $match->getPlayer1()->getRating() - $player1Model->rating,
                ]);

                $event->players()->create([
                    'p_id' => $player2Model->id,
                    'result' => $event->getPlayer2ResultByEvent(),
                    'shift' => $match->getPlayer2()->getRating() - $player2Model->rating,
                ]);

                switch ($event->result){
                    case Event::DRAW:
                        $player1Model->draw += 1;
                        $player2Model->draw += 1;
                        break;

                    case Event::PLAYER_1_WIN:
                        $player1Model->won += 1;
                        $player2Model->lost += 1;
                        break;

                    case Event::PLAYER_2_WIN:
                        $player1Model->lost += 1;
                        $player2Model->won += 1;
                        break;

                    default:
                        throw new \Exception('Incorrect event result');
                }

                $player1Model->games += 1;
                $player2Model->games += 1;
                $player1Model->rating = $match->getPlayer1()->getRating();
                $player2Model->rating = $match->getPlayer2()->getRating();

                $player1Model->save();
                $player2Model->save();
            });

            event(new BreadDataAdded($dataType, $data));

            if ($request->ajax()) {
                return response()->json(['success' => true, 'data' => $data]);
            }

            return redirect()
                ->route("voyager.{$dataType->slug}.create")
                ->with([
                    'message'    => __('voyager::generic.successfully_added_new')." {$dataType->display_name_singular}",
                    'alert-type' => 'success',
                ]);
        }
    }

    public function update(Request $request, $id)
    {
        $slug = $this->getSlug($request);

        $dataType = Voyager::model('DataType')->where('slug', '=', $slug)->first();

        // Compatibility with Model binding.
        $id = $id instanceof Model ? $id->{$id->getKeyName()} : $id;

        $data = call_user_func([$dataType->model_name, 'findOrFail'], $id);

        // Check permission
        $this->authorize('edit', $data);

        // Validate fields with ajax
        $val = $this->validateBread($request->all(), $dataType->editRows, $dataType->name, $id);

        if ($val->fails()) {
            return response()->json(['errors' => $val->messages()]);
        }

        if (!$request->ajax()) {
            $this->insertUpdateData($request, $slug, $dataType->editRows, $data);

            event(new BreadDataUpdated($dataType, $data));

            return redirect()
                ->route("voyager.{$dataType->slug}.index")
                ->with([
                    'message'    => __('voyager::generic.successfully_updated')." {$dataType->display_name_singular}",
                    'alert-type' => 'success',
                ]);
        }
    }

    /**
     * @return mixed
     * @throws \Exception
     */
    public function pagination()
    {
        $items = Event::orderBy('id', 'desc')
            ->with('players')
            ->select(['id', 'result', 'created_at']);

        return Datatables::of($items)
            ->editColumn('result', function (Event $item) {
                return Event::RESULTS[$item->result];
            })
            ->addColumn('player_1', function (Event $item) {
                return ['id' => $item->getPlayer1()->id, 'name' => $item->getPlayer1()->name ?? 'No Data'];
            })
            ->addColumn('player_2', function (Event $item) {
                return ['id' => $item->getPlayer2()->id, 'name' => $item->getPlayer2()->name ?? 'No Data'];
            })
            ->addColumn('action', function ($item) {
                return '<a href="/admin/events/'.$item->id.'/edit" class="btn btn-sm btn-primary pull-right edit"><i class="voyager-edit"></i> Edit</a>'.
                '<a href="/admin/events/'.$item->id.'" class="btn btn-sm btn-warning pull-right"><i class="voyager-eye"></i> View</a>';
            })
            ->make(true);
    }
}
