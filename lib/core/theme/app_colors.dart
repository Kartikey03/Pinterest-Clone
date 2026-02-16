/*
 * Pinterest brand color palette for light and dark themes.
 */

import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color pinterestRed = Color(0xFFE60023);
  static const Color pinterestRedDark = Color(0xFFAD081B);
  static const Color pinterestRedLight = Color(0xFFFF5247);

  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF5F5F5);
  static const Color lightSurfaceVariant = Color(0xFFEEEEEE);
  static const Color lightTextPrimary = Color(0xFF111111);
  static const Color lightTextSecondary = Color(0xFF767676);
  static const Color lightTextTertiary = Color(0xFFB3B3B3);
  static const Color lightDivider = Color(0xFFE0E0E0);
  static const Color lightOverlay = Color(0x80000000);
  static const Color lightCardBackground = Color(0xFFFFFFFF);

  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSurfaceVariant = Color(0xFF2C2C2C);
  static const Color darkTextPrimary = Color(0xFFE0E0E0);
  static const Color darkTextSecondary = Color(0xFF9E9E9E);
  static const Color darkTextTertiary = Color(0xFF616161);
  static const Color darkDivider = Color(0xFF333333);
  static const Color darkOverlay = Color(0x80000000);
  static const Color darkCardBackground = Color(0xFF1E1E1E);

  static const Color success = Color(0xFF00A86B);
  static const Color warning = Color(0xFFFFBD2E);
  static const Color error = Color(0xFFE60023);
  static const Color info = Color(0xFF0076D3);

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
  static const Color shimmerBaseDark = Color(0xFF2C2C2C);
  static const Color shimmerHighlightDark = Color(0xFF3D3D3D);

  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);
}
