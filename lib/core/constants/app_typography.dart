import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// ScrollGuard Premium Typography
/// Using Inter font family for modern, clean readability
class AppTypography {
  AppTypography._();

  // ═══════════════════════════════════════════════════════════════════════════
  // DISPLAY STYLES - Hero text, large statements
  // ═══════════════════════════════════════════════════════════════════════════

  static TextStyle get displayLarge => GoogleFonts.inter(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.5,
        height: 1.1,
        color: AppColors.textPrimary,
      );

  static TextStyle get displayMedium => GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        letterSpacing: -1.0,
        height: 1.2,
        color: AppColors.textPrimary,
      );

  static TextStyle get displaySmall => GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        height: 1.25,
        color: AppColors.textPrimary,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // HEADLINE STYLES - Section headers
  // ═══════════════════════════════════════════════════════════════════════════

  static TextStyle get headlineLarge => GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        height: 1.3,
        color: AppColors.textPrimary,
      );

  static TextStyle get headlineMedium => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        height: 1.35,
        color: AppColors.textPrimary,
      );

  static TextStyle get headlineSmall => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.4,
        color: AppColors.textPrimary,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // TITLE STYLES - Cards, dialogs
  // ═══════════════════════════════════════════════════════════════════════════

  static TextStyle get titleLarge => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: 1.4,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleMedium => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.45,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleSmall => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.45,
        color: AppColors.textPrimary,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // BODY STYLES - Main content text
  // ═══════════════════════════════════════════════════════════════════════════

  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        height: 1.55,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        height: 1.5,
        color: AppColors.textSecondary,
      );

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.2,
        height: 1.5,
        color: AppColors.textTertiary,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // LABEL STYLES - Buttons, chips, tabs
  // ═══════════════════════════════════════════════════════════════════════════

  static TextStyle get labelLarge => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
        height: 1.4,
        color: AppColors.textPrimary,
      );

  static TextStyle get labelMedium => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.4,
        color: AppColors.textSecondary,
      );

  static TextStyle get labelSmall => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.4,
        color: AppColors.textTertiary,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // SPECIAL STYLES - Breathing, motivational text
  // ═══════════════════════════════════════════════════════════════════════════

  static TextStyle get breathing => GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w300,
        letterSpacing: 2.0,
        height: 1.3,
        color: AppColors.textPrimary,
      );

  static TextStyle get motivational => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.6,
        color: AppColors.textSecondary,
      );

  static TextStyle get timer => GoogleFonts.inter(
        fontSize: 64,
        fontWeight: FontWeight.w200,
        letterSpacing: -2.0,
        height: 1.0,
        color: AppColors.primary,
      );

  static TextStyle get statValue => GoogleFonts.inter(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.0,
        height: 1.1,
        color: AppColors.textPrimary,
      );

  static TextStyle get statLabel => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.0,
        height: 1.4,
        color: AppColors.textTertiary,
      );
}
