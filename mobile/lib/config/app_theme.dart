import 'package:flutter/material.dart';

// Brand / Shared Colors
const Color brandPrimary = Color(0xFFF26B3A); // Warm orange (CTA)
const Color brandSecondary = Color(0xFF6C8B74); // Sage green
const Color brandAccent = Color(0xFFD9B88C); // Gold / heritage accent

// Light Theme Colors
class LightColors {
  static const background = Color(0xFFF8F5F1); // Warm cream
  static const surface = Color(0xFFFFFFFF); // Cards
  static const surfaceMuted = Color(0xFFEFEAE3); // Empty image placeholder

  static const textPrimary = Color(0xFF2B2B2B);
  static const textSecondary = Color(0xFF6F6F6F);
  static const textMuted = Color(0xFF9B9B9B);

  static const border = Color(0xFFE3DED7);

  static const chipBackground = Color(0xFFE6F0EA); // Sage tint
  static const chipSelected = brandSecondary;
}

// Dark Theme Colors
class DarkColors {
  static const background = Color(0xFF1E1A17); // Warm dark brown
  static const surface = Color(0xFF2A2420); // Cards
  static const surfaceMuted = Color(0xFF3A332E); // Empty image placeholder

  static const textPrimary = Color(0xFFF5F1EC);
  static const textSecondary = Color(0xFFCFC7BD);
  static const textMuted = Color(0xFF9A9288);

  static const border = Color(0xFF3D352F);

  static const chipBackground = Color(0xFF2F3B34); // Dark sage
  static const chipSelected = brandSecondary;
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: LightColors.background,
      colorScheme: ColorScheme.light(
        primary: brandPrimary,
        secondary: brandSecondary,
        surface: LightColors.surface,
        onPrimary: Colors.white,
        onSurface: LightColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: LightColors.background,
        elevation: 0,
        foregroundColor: LightColors.textPrimary,
        iconTheme: IconThemeData(color: LightColors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: LightColors.surface,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: LightColors.textPrimary,
          fontFamily: 'Playfair Display',
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: LightColors.textPrimary,
          fontFamily: 'Playfair Display',
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: LightColors.textPrimary,
          fontFamily: 'Playfair Display',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: LightColors.textPrimary,
          fontFamily: 'Manrope',
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: LightColors.textSecondary,
          fontFamily: 'Manrope',
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: LightColors.textMuted,
          fontFamily: 'Manrope',
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: LightColors.chipBackground,
        selectedColor: LightColors.chipSelected,
        labelStyle: const TextStyle(color: LightColors.textPrimary),
        secondaryLabelStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: brandPrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: DarkColors.background,
      colorScheme: ColorScheme.dark(
        primary: brandPrimary,
        secondary: brandSecondary,
        background: DarkColors.background,
        surface: DarkColors.surface,
        onPrimary: Colors.white,
        onSurface: DarkColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: DarkColors.background,
        elevation: 0,
        foregroundColor: DarkColors.textPrimary,
        iconTheme: IconThemeData(color: DarkColors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: DarkColors.surface,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: DarkColors.textPrimary,
          fontFamily: 'Playfair Display',
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: DarkColors.textPrimary,
          fontFamily: 'Playfair Display',
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: DarkColors.textPrimary,
          fontFamily: 'Playfair Display',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: DarkColors.textPrimary,
          fontFamily: 'Manrope',
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: DarkColors.textSecondary,
          fontFamily: 'Manrope',
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: DarkColors.textMuted,
          fontFamily: 'Manrope',
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: DarkColors.chipBackground,
        selectedColor: DarkColors.chipSelected,
        labelStyle: const TextStyle(color: DarkColors.textPrimary),
        secondaryLabelStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: brandPrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      ),
    );
  }
}
