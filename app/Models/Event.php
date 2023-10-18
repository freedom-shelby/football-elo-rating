<?php

namespace App\Models;

use App\Models\Order;
use Grimzy\LaravelMysqlSpatial\Eloquent\SpatialTrait;
use Illuminate\Notifications\Notifiable;
use Illuminate\Foundation\Auth\User as Authenticatable;
use TCG\Voyager\Traits\Spatial;

class Event extends Authenticatable
{
    use Notifiable;

    const DRAW = 0;
    const PLAYER_1_WIN = 1;
    const PLAYER_2_WIN = 2;

    const RESULTS = [
        self::DRAW => 'Draw',
        self::PLAYER_1_WIN => 'Player 1 Win',
        self::PLAYER_2_WIN => 'Player 2 Win',
    ];


    protected $table = 'events';
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
//    protected $fillable = [
//        'name', 'email', 'phone', 'password',
//    ];

    protected $guarded = ['id'];


    protected $casts = [
        'created_at' => 'datetime:d-m-Y',
    ];

    public function players()
    {
        return $this->hasMany('App\Models\PlayerEvent', 'e_id');
    }

    public function getPlayer1()
    {
        if($this->players->isEmpty()){
            return false;
        }

        return $this->players->get(0)->getPlayer();
    }

    public function getPlayer2()
    {
        if($this->players->isEmpty()){
            return false;
        }

        return $this->players->get(1)->getPlayer();
    }

    public function tournament()
    {
        return $this->belongsTo('App\Models\Tournament', 'season_id');
    }

    public function getTournament()
    {
        return $this->tournament()->first();
    }

    /**
     * @return int
     * @throws \Exception
     */
    public function getPlayer1ResultByEvent()
    {
        switch ($this->result){
            case static::DRAW:
                return PlayerEvent::DRAW;
            case static::PLAYER_1_WIN:
                return PlayerEvent::WIN;
            case static::PLAYER_2_WIN:
                return PlayerEvent::LOSS;
            default:
                throw new \Exception('Incorrect event result');
        }
    }

    /**
     * @return int
     * @throws \Exception
     */
    public function getPlayer2ResultByEvent()
    {
        switch ($this->result){
            case static::DRAW:
                return PlayerEvent::DRAW;
            case static::PLAYER_1_WIN:
                return PlayerEvent::LOSS;
            case static::PLAYER_2_WIN:
                return PlayerEvent::WIN;
            default:
                throw new \Exception('Incorrect event result');
        }
    }

    //todo:: remove after this line
    public function orders()
    {
        return $this->hasMany('App\Models\Order', 'sender_id');
    }

    public function courierRelatedOrders()
    {
        return $this->belongsToMany('App\Models\Order', 'couriers_requests', 'user_id', 'order_id');
    }

    public function senderRelatedOrdersRequests()
    {
        return $this->hasManyThrough('App\Models\CourierRequest', 'App\Models\Order', 'sender_id', 'order_id');
    }

    public function courierOrders()
    {
        return $this->hasMany('App\Models\Order', 'courier_id');
    }

    public function courierRequestOrders()
    {
        return $this->hasMany('App\Models\CourierRequest', 'user_id');
    }

    /**
     * Расчёт рейтинга
     *
     * @param $rate
     * @return bool
     */
    public function appendRating($rate)
    {
        $rateTotalCounts = $this->courierOrders()
            ->where('status', Order::COMPLETED)
            ->count();

        $lastTotalCounts = $rateTotalCounts - 1;

        /**
         * Математический расчёт рейтинга
         */
        $data = ($this->rate * $lastTotalCounts + $rate) / $rateTotalCounts;

        return $this->update([
            'rate' => $data,
        ]);
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasOne
     */
    public function bank()
    {
        return $this->hasOne('App\Models\UserBank', 'user_id');
    }

    public function getBank()
    {
        return $this->bank()->first();
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function paymentMethodCredential()
    {
        return $this->hasMany('App\Models\PaymentMethodCredential', 'user_id');
    }

    public function updateBankInPending($amount)
    {
        $model = $this->getBank();

        $amount += $model->in_pending;

        $model->update([
            'in_pending' => $amount,
        ]);
    }

    public function updateBankReceived($amount)
    {
        $model = $this->getBank();

        $amount += $model->received;

        $model->update([
            'received' => $amount,
        ]);
    }

    public function recognizeDeviceBrand()
    {
        $device = json_decode($this->device);

        switch ($device['brand']){
            case "ios":
                return "ios";
            default:
                return "android";
        }
    }

    public function routeNotificationForSmsService()
    {
        return $this->phone;
    }

    public function generateRadiusBySpeedRatio($speed)
    {
        $radius = $this->defined_radius ?: setting('api.default_radius');
        $radius += self::SPEED_RATIO * $speed;

        return $radius;
    }
}
