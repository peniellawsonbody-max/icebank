<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class CryptoTransaction extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'crypto',
        'type',
        'amount_eur',
        'amount_crypto',
        'address',
        'status',
        'tx_hash',
    ];

    protected $casts = [
        'amount_eur'    => 'decimal:2',
        'amount_crypto' => 'decimal:8',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
