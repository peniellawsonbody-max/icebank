<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('crypto_transactions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')
                  ->constrained()
                  ->onDelete('cascade');
            $table->string('crypto');
            $table->enum('type', [
                'buy',
                'sell',
                'send',
                'receive',
            ]);
            $table->decimal('amount_eur', 10, 2)->default(0);
            $table->decimal('amount_crypto', 18, 8)->default(0);
            $table->string('address')->nullable();
            $table->string('tx_hash')->nullable();
            $table->enum('status', [
                'pending',
                'completed',
                'failed',
            ])->default('pending');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('crypto_transactions');
    }
};
