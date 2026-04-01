<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Card extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'card_number',
        'expiry',
        'cvv',
        'contactless',
        'online_payment',
        'international',
        'blocked',
        'opposition',
        'pin',
    ];

    protected $hidden = [
        'cvv',
        'pin',
        'card_number',
    ];

    protected $casts = [
        'contactless'    => 'boolean',
        'online_payment' => 'boolean',
        'international'  => 'boolean',
        'blocked'        => 'boolean',
        'opposition'     => 'boolean',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function isBlocked()
    {
        return $this->blocked || $this->opposition;
    }
}
