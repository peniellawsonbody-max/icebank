cat > routes/api.php << 'ROUTES'
<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\AccountController;
use App\Http\Controllers\TransactionController;
use App\Http\Controllers\CryptoController;
use App\Http\Controllers\CardController;
use App\Http\Controllers\AIController;

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/me', [AuthController::class, 'me']);
    Route::get('/balance', [AccountController::class, 'balance']);
    Route::get('/rib', [AccountController::class, 'rib']);
    Route::get('/transactions', [TransactionController::class, 'index']);
    Route::post('/transfer', [TransactionController::class, 'transfer']);
    Route::get('/transactions/{id}', [TransactionController::class, 'show']);
    Route::get('/crypto/prices', [CryptoController::class, 'prices']);
    Route::get('/crypto/portfolio', [CryptoController::class, 'portfolio']);
    Route::post('/crypto/buy', [CryptoController::class, 'buy']);
    Route::post('/crypto/sell', [CryptoController::class, 'sell']);
    Route::post('/crypto/send', [CryptoController::class, 'send']);
    Route::get('/card', [CardController::class, 'show']);
    Route::put('/card/settings', [CardController::class, 'updateSettings']);
    Route::post('/card/opposition', [CardController::class, 'opposition']);
    Route::post('/ai/chat', [AIController::class, 'chat']);
});
