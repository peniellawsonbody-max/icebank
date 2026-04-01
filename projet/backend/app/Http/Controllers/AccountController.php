<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Transaction;

class AccountController extends Controller
{
    public function balance(Request $request)
    {
        $user = $request->user();

        $totalIn = Transaction::where('user_id', $user->id)
            ->where('type', 'credit')
            ->sum('amount');

        $totalOut = Transaction::where('user_id', $user->id)
            ->where('type', 'debit')
            ->sum('amount');

        $balance = $totalIn - $totalOut;

        return response()->json([
            'user'    => $user->name,
            'balance' => number_format($balance, 2),
            'currency' => 'EUR',
        ]);
    }

    public function rib(Request $request)
    {
        $user = $request->user();

        return response()->json([
            'iban'  => 'FR76 3000 6000 0112 3456 7890 189',
            'bic'   => 'BNPAFRPP',
            'bank'  => 'IceBank',
            'owner' => $user->name,
        ]);
    }
}
