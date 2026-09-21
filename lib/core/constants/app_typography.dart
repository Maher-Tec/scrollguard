import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// ScrollGuard Premium Typography — Mindful Pause (Digital Sanctuary)
/// Using Plus Jakarta Sans for serene humanist geometry and contemporary clarity
class AppTypography {
  AppTypography._();

  // ═══════════════════════════════════════════════════════════════════════════
  // DISPLAY STYLES - Hero text, large statements
  // ═══════════════════════════════════════════════════════════════════════════

  static TextStyle get displayLarge => GoogleFonts.plusJakartaSans(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        height: 1.1,
        color: AppColors.textPrimary,
      );

  static TextStyle get displayMedium => GoogleFonts.plusJakartaSans(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.2,
        color: AppColors.textPrimary,
      );

  static TextStyle get displaySmall => GoogleFonts.plusJakartaSans(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        height: 1.25,
        color: AppColors.textPrimary,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // HEADLINE STYLES - Section headers
  // ═══════════════════════════════════════════════════════════════════════════

  static TextStyle get headlineLarge => GoogleFonts.plusJakartaSans(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        height: 1.25,
        color: AppColors.textPrimary,
      );

  static TextStyle get headlineMedium => GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        height: 1.3,
        color: AppColors.textPrimary,
      );

  static TextStyle get headlineSmall => GoogleFonts.plusJakartaSans(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
        height: 1.35,
        color: AppColors.textPrimary,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // TITLE STYLES - Cards, dialogs
  // ═══════════════════════════════════════════════════════════════════════════

  static TextStyle get titleLarge => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
        height: 1.35,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleMedium => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.4,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleSmall => GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.4,
        color: AppColors.textPrimary,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // BODY STYLES - Main content text
  // ═══════════════════════════════════════════════════════════════════════════

  static TextStyle get bodyLarge => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.5,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyMedium => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
        height: 1.45,
        color: AppColors.textSecondary,
      );

  static TextStyle get bodySmall => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        height: 1.4,
        color: AppColors.textSecondary,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // LABEL STYLES - Buttons, chips, tabs
  // ═══════════════════════════════════════════════════════════════════════════

  static TextStyle get labelLarge => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        height: 1.35,
        color: AppColors.textPrimary,
      );

  static TextStyle get labelMedium => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
        height: 1.35,
        color: AppColors.textSecondary,
      );

  static TextStyle get labelSmall => GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
        height: 1.35,
        color: AppColors.textTertiary,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // SPECIAL STYLES - Breathing, motivational text
  // ═══════════════════════════════════════════════════════════════════════════

  static TextStyle get breathing => GoogleFonts.plusJakartaSans(
        fontSize: 32,
        fontWeight: FontWeight.w300,
        letterSpacing: 1.5,
        height: 1.3,
        color: AppColors.textPrimary,
      );

  static TextStyle get motivational => GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.5,
        color: AppColors.textSecondary,
      );

  static TextStyle get timer => GoogleFonts.plusJakartaSans(
        fontSize: 48,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.5,
        height: 1.0,
        color: AppColors.textPrimary,
      );

  static TextStyle get statValue => GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        height: 1.2,
        color: AppColors.textPrimary,
      );

  static TextStyle get statLabel => GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
        height: 1.3,
        color: AppColors.textSecondary,
      );
}
