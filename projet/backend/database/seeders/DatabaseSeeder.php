<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use App\Models\Card;
use App\Models\Transaction;
use App\Models\CryptoWallet;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // Créer utilisateur de test
        $user = User::create([
            'name'     => 'Tevi Elolo Peniel Lawson Body',
            'email'    => 'peniel@icebank.com',
            'password' => bcrypt('icebank2026'),
            'phone'    => '+33 6 12 34 56 78',
            'address'  => 'Châtillon, Île-de-France',
            'balance'  => 304.85,
        ]);

        // Créer carte
        Card::create([
            'user_id'        => $user->id,
            'card_number'    => '5290000000001109',
            'expiry'         => '11/30',
            'cvv'            => '123',
            'pin'            => bcrypt('1234'),
            'contactless'    => true,
            'online_payment' => true,
            'international'  => true,
            'blocked'        => false,
            'opposition'     => false,
        ]);

        // Créer transactions
        Transaction::create([
            'user_id'     => $user->id,
            'type'        => 'debit',
            'amount'      => 8.00,
            'label'       => 'LE CASS\'CROUTE D',
            'status'      => 'pending',
        ]);

        Transaction::create([
            'user_id' => $user->id,
            'type'    => 'debit',
            'amount'  => 60.00,
            'label'   => 'WINAMAX',
            'status'  => 'completed',
        ]);

        Transaction::create([
            'user_id' => $user->id,
            'type'    => 'debit',
            'amount'  => 10.01,
            'label'   => 'cpqck',
            'status'  => 'completed',
        ]);

        Transaction::create([
            'user_id' => $user->id,
            'type'    => 'credit',
            'amount'  => 150.00,
            'label'   => 'Virement reçu',
            'status'  => 'completed',
        ]);

        // Créer portefeuille crypto
        CryptoWallet::create([
            'user_id'   => $user->id,
            'crypto'    => 'Bitcoin',
            'symbol'    => 'BTC',
            'amount'    => 0.00400000,
            'value_eur' => 328.56,
            'address'   => '1A2B3C4D5E6F7G8H9I0J',
        ]);

        CryptoWallet::create([
            'user_id'   => $user->id,
            'crypto'    => 'Ethereum',
            'symbol'    => 'ETH',
            'amount'    => 0.48000000,
            'value_eur' => 907.20,
            'address'   => '0x3Fa8e2B1C9d047A6b',
        ]);
    }
}
