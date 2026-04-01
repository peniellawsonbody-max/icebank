<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use App\Models\Transaction;
use App\Models\CryptoWallet;

class AIController extends Controller
{
    public function chat(Request $request)
    {
        $request->validate([
            'message' => 'required|string',
        ]);

        $user = $request->user();

        // Contexte bancaire de l'utilisateur
        $transactions = Transaction::where('user_id', $user->id)
            ->orderBy('created_at', 'desc')
            ->take(5)
            ->get();

        $wallets = CryptoWallet::where('user_id', $user->id)->get();

        $context = "Tu es IceAI, l'assistant bancaire intelligent de IceBank. 
        L'utilisateur s'appelle {$user->name}.
        Ses 5 dernières transactions : " . $transactions->toJson() . "
        Son portefeuille crypto : " . $wallets->toJson() . "
        Réponds en français, de manière concise et professionnelle.
        Tu peux analyser les dépenses, donner des conseils financiers,
        expliquer les cryptomonnaies et aider avec les virements.";

        $response = Http::withHeaders([
            'Authorization' => 'Bearer ' . env('OPENAI_API_KEY'),
            'Content-Type'  => 'application/json',
        ])->post('https://api.openai.com/v1/chat/completions', [
            'model'    => 'gpt-3.5-turbo',
            'messages' => [
                ['role' => 'system', 'content' => $context],
                ['role' => 'user',   'content' => $request->message],
            ],
            'max_tokens'  => 500,
            'temperature' => 0.7,
        ]);

        $reply = $response->json()['choices'][0]['message']['content'] ?? 
                 'Désolé, je ne peux pas répondre pour le moment.';

        return response()->json([
            'reply' => $reply,
        ]);
    }
}
