<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;
use ReflectionClass;

class Tournament extends Model
{
    protected $table = 'seasons';

    protected $guarded = ['id'];

    /**
     * The attributes that should be mutated to dates.
     *
     * @var array
     */
    protected $dates = [
        'created_at',
        'updated_at',
    ];

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'id' => 'int',
        'created_at' => 'dateTime:d-m-Y',
    ];

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


    //todo:: remove after this line
    public function sender()
    {
        return $this->belongsTo('App\Models\ApiUser', 'sender_id');
    }

    public function getSender()
    {
        return $this->sender()->first();
    }

    public function courier()
    {
        return $this->belongsTo('App\Models\ApiUser', 'courier_id');
    }

    public function getCourier()
    {
        return $this->courier()->first();
    }

    public function hasExpired()
    {
        return (bool) Carbon::now()->gt($this->expires_at);
    }

    public function setDeadline($value)
    {
        $this->attributes['deadline'] =  Carbon::parse($value);
    }

    public function packageSpecification()
    {
        return $this->belongsTo('App\Models\PackageSpecification', 'package_specification_id');
    }

    public function getPackageSpecification()
    {
        return $this->packageSpecification()->first();
    }

    public function senderDetails()
    {
        return $this->belongsTo('App\Models\AddressDetails', 'sender_details_id');
    }

    public function getSenderDetails()
    {
        return $this->senderDetails()->first();
    }

    /**
     * todo:: Nuyne inch clientDetails -@ , ogtagor&vum e OrderTranformerum EagerLoad -i hamar
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function client()
    {
        return $this->belongsTo('App\Models\AddressDetails', 'client_details_id');
    }

    public function clientDetails()
    {
        return $this->belongsTo('App\Models\AddressDetails', 'client_details_id');
    }

    public function getClientDetails()
    {
        return $this->clientDetails()->first();
    }

    public function couriersRequests()
    {
        return $this->hasMany('App\Models\CourierRequest', 'order_id')->orderBy('amount', 'ASC');
    }

    public function code()
    {
        return $this->hasOne('App\Models\Code', 'order_id');
    }

    public function getCode()
    {
        return $this->code()->first();
    }

    public function payment()
    {
        return $this->hasOne('App\Models\Payment', 'order_id');
    }

    public function getPayment()
    {
        return $this->payment()->first();
    }

    public function calcAmountByCourierAmount($courierAmount)
    {
        $amount = 0;

        //todo:: karogh e insurance_amount -@ ijni nerqev (?)
        $amount += $this->insurance_amount;
        $amount += $courierAmount;

        $amount += $amount * setting('api.fee') / 100;

        return (float) $amount;
    }

    public function getStatusName()
    {
        $class = new ReflectionClass(__CLASS__);
        $constants = array_flip($class->getConstants());

        return $constants[$this->status];
    }
}
