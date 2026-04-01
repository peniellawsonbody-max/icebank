<?php

namespace App\Http\Controllers;

use App\Models\Transaction;
use Illuminate\Http\Request;

class TransactionController extends Controller
{
    public function index(Request $request)
    {
        $transactions = Transaction::where('user_id', $request->user()->id)
            ->orderBy('created_at', 'desc')
            ->paginate(20);

        return response()->json($transactions);
    }

    public function transfer(Request $request)
    {
        $request->validate([
            'beneficiary' => 'required|string',
            'amount'      => 'required|numeric|min:0.01',
            'motif'       => 'nullable|string',
        ]);

        $transaction = Transaction::create([
            'user_id'     => $request->user()->id,
            'type'        => 'debit',
            'amount'      => $request->amount,
            'label'       => 'Virement vers ' . $request->beneficiary,
            'motif'       => $request->motif,
            'status'      => 'pending',
        ]);

        return response()->json([
            'message'     => 'Virement initié avec succès',
            'transaction' => $transaction,
        ], 201);
    }

    public function show($id)
    {
        $transaction = Transaction::findOrFail($id);

        return response()->json($transaction);
    }
}
