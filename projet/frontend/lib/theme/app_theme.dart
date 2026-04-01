import 'package:flutter/material.dart';

class AppTheme {
  // Couleurs IceBank
  static const Color primary     = Color(0xFF63B3ED);
  static const Color secondary   = Color(0xFF4FD1C5);
  static const Color background  = Color(0xFF0A0F1E);
  static const Color surface     = Color(0xFF111827);
  static const Color card        = Color(0xFF1A2235);
  static const Color green       = Color(0xFF68D391);
  static const Color red         = Color(0xFFFC8181);
  static const Color gold        = Color(0xFFF6E05E);
  static const Color purple      = Color(0xFFB794F4);
  static const Color textPrimary = Color(0xFFE2E8F0);
  static const Color textMuted   = Color(0xFF718096);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary:   primary,
        secondary: secondary,
        surface:   surface,
        error:     red,
      ),
      fontFamily: 'Poppins',
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color:      textPrimary,
          fontSize:   22,
          fontWeight: FontWeight.w700,
          fontFamily: 'Poppins',
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor:      surface,
        selectedItemColor:    secondary,
        unselectedItemColor:  textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 24,
          ),
          textStyle: const TextStyle(
            fontSize:   15,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: primary.withOpacity(0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: primary.withOpacity(0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary),
        ),
        labelStyle: const TextStyle(color: textMuted),
        hintStyle:  const TextStyle(color: textMuted),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textPrimary, fontSize: 32, fontWeight: FontWeight.w700,
        ),
        headlineMedium: TextStyle(
          color: textPrimary, fontSize: 24, fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: textPrimary, fontSize: 18, fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: textPrimary, fontSize: 16, fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: textMuted, fontSize: 14, fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
