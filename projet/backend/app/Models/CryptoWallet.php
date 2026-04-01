<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class CryptoWallet extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'crypto',
        'symbol',
        'amount',
        'value_eur',
        'address',
    ];

    protected $casts = [
        'amount'    => 'decimal:8',
        'value_eur' => 'decimal:2',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function transactions()
    {
        return $this->hasMany(CryptoTransaction::class, 'crypto', 'symbol');
    }
}
