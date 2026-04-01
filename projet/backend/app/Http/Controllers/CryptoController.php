<?php

namespace App\Http\Controllers;

use App\Models\CryptoWallet;
use App\Models\CryptoTransaction;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class CryptoController extends Controller
{
    public function prices()
    {
        $response = Http::get('https://api.coingecko.com/api/v3/simple/price', [
            'ids'           => 'bitcoin,ethereum,tether,solana,ripple,avalanche-2',
            'vs_currencies' => 'eur',
            'include_24hr_change' => 'true',
        ]);

        return response()->json($response->json());
    }

    public function portfolio(Request $request)
    {
        $wallets = CryptoWallet::where('user_id', $request->user()->id)->get();

        return response()->json([
            'wallets' => $wallets,
            'total'   => $wallets->sum('value_eur'),
        ]);
    }

    public function buy(Request $request)
    {
        $request->validate([
            'crypto'     => 'required|string',
            'amount_eur' => 'required|numeric|min:1',
        ]);

        $wallet = CryptoWallet::updateOrCreate(
            [
                'user_id' => $request->user()->id,
                'crypto'  => $request->crypto,
            ],
            [
                'value_eur' => \DB::raw('value_eur + ' . $request->amount_eur),
            ]
        );

        CryptoTransaction::create([
            'user_id'    => $request->user()->id,
            'crypto'     => $request->crypto,
            'type'       => 'buy',
            'amount_eur' => $request->amount_eur,
            'status'     => 'completed',
        ]);

        return response()->json([
            'message' => 'Achat effectué avec succès',
            'wallet'  => $wallet,
        ], 201);
    }

    public function sell(Request $request)
    {
        $request->validate([
            'crypto'     => 'required|string',
            'amount_eur' => 'required|numeric|min:1',
        ]);

        CryptoTransaction::create([
            'user_id'    => $request->user()->id,
            'crypto'     => $request->crypto,
            'type'       => 'sell',
            'amount_eur' => $request->amount_eur,
            'status'     => 'completed',
        ]);

        return response()->json([
            'message' => 'Vente effectuée avec succès',
        ]);
    }

    public function send(Request $request)
    {
        $request->validate([
            'crypto'  => 'required|string',
            'address' => 'required|string',
            'amount'  => 'required|numeric|min:0.00001',
        ]);

        CryptoTransaction::create([
            'user_id'    => $request->user()->id,
            'crypto'     => $request->crypto,
            'type'       => 'send',
            'address'    => $request->address,
            'amount_eur' => $request->amount,
            'status'     => 'pending',
        ]);

        return response()->json([
            'message' => 'Envoi en cours de traitement',
        ]);
    }
}
