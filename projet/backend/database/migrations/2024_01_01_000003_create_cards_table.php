<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('cards', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')
                  ->constrained()
                  ->onDelete('cascade');
            $table->string('card_number');
            $table->string('expiry');
            $table->string('cvv');
            $table->string('pin')->nullable();
            $table->boolean('contactless')->default(true);
            $table->boolean('online_payment')->default(true);
            $table->boolean('international')->default(true);
            $table->boolean('blocked')->default(false);
            $table->boolean('opposition')->default(false);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('cards');
    }
};
