<?php

namespace App\Http\Controllers\Front;


use App\Http\Controllers\Controller;
use App\Models\Event;
use App\Models\Player;

class FrontController extends Controller
{
    public function index()
    {
        $players = Player::active()
            ->firstRated()
            ->get();

        $events = Event::with('players')
            ->orderBy('id', 'desc')
            ->take(12)
            ->get();

        return view('index')
            ->with('players', $players)
            ->with('events', $events);
    }
	
    public function test()
    {
        $p1 = 1920;
        $p2 = 1900;
		$k = 40;
		
		$EaP1 = 1 / (1 + (10 ** (($p2 - $p1) / 400)));
		
		$p1New = $p1 + $k * (0.5 - $EaP1);
		
		$EaP2 = 1 / (1 + (10 ** (($p1 - $p2) / 400)));
		
		$p2New = $p2 + $k * (0.5 - $EaP2);
		
		echo "<pre>";
		echo $p1New;
		echo "</pre>";
		
		echo "<pre>";
		echo $p2New;
		echo "</pre>";
		die;
    }
}
