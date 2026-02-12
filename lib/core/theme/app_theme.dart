import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Builds the complete [ThemeData] for light and dark modes.
///
/// Configures Material 3 components to match Pinterest's
/// clean, minimal design language.
abstract final class AppTheme {
  // ═══════════════════════════════════════════════════════════════════════
  //  LIGHT THEME
  // ═══════════════════════════════════════════════════════════════════════
  static ThemeData get light {
    final colorScheme = ColorScheme.light(
      primary: AppColors.pinterestRed,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.pinterestRedLight,
      secondary: AppColors.lightTextSecondary,
      onSecondary: AppColors.white,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,
      surfaceContainerHighest: AppColors.lightSurfaceVariant,
      error: AppColors.error,
      onError: AppColors.white,
      outline: AppColors.lightDivider,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.lightBackground,
      textTheme: AppTypography.textTheme.apply(
        bodyColor: AppColors.lightTextPrimary,
        displayColor: AppColors.lightTextPrimary,
      ),

      // ── AppBar ───────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0.5,
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.lightTextPrimary,
        surfaceTintColor: AppColors.transparent,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: AppColors.lightTextPrimary,
        ),
      ),

      // ── Bottom Nav ───────────────────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.lightBackground,
        selectedItemColor: AppColors.lightTextPrimary,
        unselectedItemColor: AppColors.lightTextTertiary,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 8,
        selectedLabelStyle: AppTypography.labelSmall.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTypography.labelSmall,
      ),

      // ── Card ─────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.lightCardBackground,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
      ),

      // ── Elevated Button ──────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.pinterestRed,
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusFull,
          ),
          textStyle: AppTypography.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── Text Button ──────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.lightTextPrimary,
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // ── Input Decoration ─────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusFull,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusFull,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusFull,
          borderSide: const BorderSide(color: AppColors.pinterestRed, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.lightTextTertiary,
        ),
      ),

      // ── Divider ──────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.lightDivider,
        thickness: 1,
        space: 0,
      ),

      // ── Chip ─────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightSurfaceVariant,
        selectedColor: AppColors.lightTextPrimary,
        labelStyle: AppTypography.labelMedium,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusFull,
        ),
        side: BorderSide.none,
        padding: AppSpacing.paddingHorizontalSm,
      ),

      // ── Splash / Ripple ──────────────────────────────────────────────
      splashFactory: InkSparkle.splashFactory,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  DARK THEME
  // ═══════════════════════════════════════════════════════════════════════
  static ThemeData get dark {
    final colorScheme = ColorScheme.dark(
      primary: AppColors.pinterestRed,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.pinterestRedDark,
      secondary: AppColors.darkTextSecondary,
      onSecondary: AppColors.white,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      surfaceContainerHighest: AppColors.darkSurfaceVariant,
      error: AppColors.error,
      onError: AppColors.white,
      outline: AppColors.darkDivider,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: AppTypography.textTheme.apply(
        bodyColor: AppColors.darkTextPrimary,
        displayColor: AppColors.darkTextPrimary,
      ),

      // ── AppBar ───────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0.5,
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkTextPrimary,
        surfaceTintColor: AppColors.transparent,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: AppColors.darkTextPrimary,
        ),
      ),

      // ── Bottom Nav ───────────────────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.darkBackground,
        selectedItemColor: AppColors.darkTextPrimary,
        unselectedItemColor: AppColors.darkTextTertiary,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 8,
        selectedLabelStyle: AppTypography.labelSmall.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTypography.labelSmall,
      ),

      // ── Card ─────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.darkCardBackground,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
      ),

      // ── Elevated Button ──────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.pinterestRed,
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusFull,
          ),
          textStyle: AppTypography.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── Text Button ──────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.darkTextPrimary,
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // ── Input Decoration ─────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusFull,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusFull,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusFull,
          borderSide: const BorderSide(color: AppColors.pinterestRed, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.darkTextTertiary,
        ),
      ),

      // ── Divider ──────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.darkDivider,
        thickness: 1,
        space: 0,
      ),

      // ── Chip ─────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkSurfaceVariant,
        selectedColor: AppColors.darkTextPrimary,
        labelStyle: AppTypography.labelMedium,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusFull,
        ),
        side: BorderSide.none,
        padding: AppSpacing.paddingHorizontalSm,
      ),

      // ── Splash / Ripple ──────────────────────────────────────────────
      splashFactory: InkSparkle.splashFactory,
    );
  }
}
