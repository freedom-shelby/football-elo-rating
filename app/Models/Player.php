<?php

namespace App\Models;

use Grimzy\LaravelMysqlSpatial\Eloquent\SpatialTrait;
use Illuminate\Notifications\Notifiable;
use Illuminate\Foundation\Auth\User as Authenticatable;
use TCG\Voyager\Traits\Spatial;

class Player extends Authenticatable
{
    use Notifiable;

    protected $table = 'players';
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

    /**
     * Scope a query to only include popular users.
     *
     * @param \Illuminate\Database\Eloquent\Builder $query
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function scopeFirstRated($query)
    {
        return $query->orderBy('rating', 'desc');
    }

    /**
     * Scope a query to only include active users.
     *
     * @param \Illuminate\Database\Eloquent\Builder $query
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function scopeActive($query)
    {
        return $query->where('is_active', 1);
    }

    public function getWinRateAttribute()
    {
        if(! $this->games){
            return 0;
        }

        return number_format($this->won * 100 /  $this->games, 1);
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
