<?php

namespace App\Http\Controllers;

use App\Models\Card;
use Illuminate\Http\Request;

class CardController extends Controller
{
    public function show(Request $request)
    {
        $card = Card::where('user_id', $request->user()->id)->first();

        if (!$card) {
            return response()->json([
                'message' => 'Aucune carte trouvée',
            ], 404);
        }

        return response()->json([
            'card_number'    => '5290 XXXX XXXX ' . substr($card->card_number, -4),
            'expiry'         => $card->expiry,
            'holder'         => $request->user()->name,
            'contactless'    => $card->contactless,
            'online_payment' => $card->online_payment,
            'international'  => $card->international,
            'blocked'        => $card->blocked,
        ]);
    }

    public function updateSettings(Request $request)
    {
        $request->validate([
            'contactless'    => 'boolean',
            'online_payment' => 'boolean',
            'international'  => 'boolean',
            'blocked'        => 'boolean',
        ]);

        $card = Card::where('user_id', $request->user()->id)->first();

        $card->update([
            'contactless'    => $request->contactless ?? $card->contactless,
            'online_payment' => $request->online_payment ?? $card->online_payment,
            'international'  => $request->international ?? $card->international,
            'blocked'        => $request->blocked ?? $card->blocked,
        ]);

        return response()->json([
            'message' => 'Paramètres mis à jour',
            'card'    => $card,
        ]);
    }

    public function opposition(Request $request)
    {
        $card = Card::where('user_id', $request->user()->id)->first();

        $card->update([
            'blocked'    => true,
            'opposition' => true,
        ]);

        return response()->json([
            'message' => 'Opposition effectuée avec succès. 
                         Votre carte est définitivement bloquée.',
        ]);
    }
}
