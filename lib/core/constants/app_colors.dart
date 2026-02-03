import 'package:flutter/material.dart';

/// ScrollGuard Premium Color Palette
/// A calm, sophisticated dark theme with soft teal accents
class AppColors {
  AppColors._();

  // ═══════════════════════════════════════════════════════════════════════════
  // PRIMARY COLORS - Soft Teal (Calm, Peace, Mindfulness)
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const Color primary = Color(0xFF4FD1C5);
  static const Color primaryLight = Color(0xFF80DEEA);
  static const Color primaryDark = Color(0xFF38B2AC);
  static const Color primaryMuted = Color(0xFF2D9A91);
  
  // Gradient for premium effects
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4FD1C5), Color(0xFF38B2AC)],
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // ACCENT COLORS - Soft Lavender (Breathing, Relaxation)
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const Color accent = Color(0xFF9F7AEA);
  static const Color accentLight = Color(0xFFB794F4);
  static const Color accentDark = Color(0xFF805AD5);
  static const Color accentMuted = Color(0xFF6B46C1);
  
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFB794F4), Color(0xFF9F7AEA)],
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // BACKGROUND COLORS - Deep Navy/Charcoal
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const Color background = Color(0xFF0A0E14);
  static const Color backgroundSecondary = Color(0xFF0F1419);
  static const Color surface = Color(0xFF151B23);
  static const Color surfaceLight = Color(0xFF1A222D);
  static const Color surfaceElevated = Color(0xFF1F2937);
  static const Color surfaceCard = Color(0xFF1E2530);
  
  // Glassmorphism effect colors
  static const Color glass = Color(0x1AFFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);

  // ═══════════════════════════════════════════════════════════════════════════
  // TEXT COLORS
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textTertiary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF475569);
  static const Color textOnPrimary = Color(0xFF0A0E14);

  // ═══════════════════════════════════════════════════════════════════════════
  // STATUS COLORS
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const Color success = Color(0xFF68D391);
  static const Color successLight = Color(0xFF9AE6B4);
  static const Color warning = Color(0xFFF6AD55);
  static const Color warningLight = Color(0xFFFBD38D);
  static const Color error = Color(0xFFFC8181);
  static const Color errorLight = Color(0xFFFEB2B2);
  static const Color info = Color(0xFF63B3ED);

  // ═══════════════════════════════════════════════════════════════════════════
  // BREATHING ANIMATION COLORS
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const Color breatheInhale = Color(0xFF4FD1C5);
  static const Color breatheHold = Color(0xFF9F7AEA);
  static const Color breatheExhale = Color(0xFF68D391);
  
  static const RadialGradient breatheGlow = RadialGradient(
    colors: [
      Color(0x404FD1C5),
      Color(0x204FD1C5),
      Color(0x004FD1C5),
    ],
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // SOCIAL APP BRAND COLORS
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const Color instagram = Color(0xFFE1306C);
  static const Color tiktok = Color(0xFF00F2EA);
  static const Color youtube = Color(0xFFFF0000);
  static const Color facebook = Color(0xFF1877F2);

  // ═══════════════════════════════════════════════════════════════════════════
  // UTILITY
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const Color divider = Color(0xFF2D3748);
  static const Color shimmer = Color(0xFF2A3441);
  static const Color overlay = Color(0xCC0A0E14);
  static const Color scrim = Color(0x99000000);
  
  // Premium shimmer gradient for loading states
  static const LinearGradient shimmerGradient = LinearGradient(
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    colors: [
      Color(0xFF1A222D),
      Color(0xFF2A3441),
      Color(0xFF1A222D),
    ],
    stops: [0.0, 0.5, 1.0],
  );
}
