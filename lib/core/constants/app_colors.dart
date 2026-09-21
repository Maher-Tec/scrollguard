import 'package:flutter/material.dart';

/// ScrollGuard Premium Color Palette
/// A calm, sophisticated dark theme with soft teal accents
class AppColors {
  AppColors._();

  // ═══════════════════════════════════════════════════════════════════════════
  // PRIMARY COLORS - Electric Sea-Glass Teal / Mint
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color primary = Color(0xFF57F1DB);
  static const Color primaryContainer = Color(0xFF2DD4BF);
  static const Color primaryFixedDim = Color(0xFF3CDDC7);
  static const Color onPrimary = Color(0xFF003731);
  static const Color onPrimaryContainer = Color(0xFF00574D);
  static const Color primaryLight = Color(0xFF62FAE3);
  static const Color primaryDark = Color(0xFF14B8A6);
  static const Color primaryMuted = Color(0xFF0D9488);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF57F1DB), Color(0xFF2DD4BF)],
  );

  static const LinearGradient gaugeTealGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF62FAE3), Color(0xFF2DD4BF), Color(0xFF00574D)],
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // ACCENT COLORS - Soft Lavender (Breathing & Stillness)
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color accent = Color(0xFF9F7AEA);
  static const Color accentLight = Color(0xFFB794F4);
  static const Color accentDark = Color(0xFF805AD5);
  static const Color accentMuted = Color(0xFF6B46C1);

  // Breathing Animation Colors
  static const Color breatheInhale = Color(0xFF57F1DB);
  static const Color breatheHold = Color(0xFF9F7AEA);
  static const Color breatheExhale = Color(0xFF3CDDC7);

  static const RadialGradient breatheGlow = RadialGradient(
    colors: [
      Color(0x4057F1DB),
      Color(0x2057F1DB),
      Color(0x0057F1DB),
    ],
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // BACKGROUND & SURFACES - Deep Obsidian & Charcoal
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color background = Color(0xFF090C10);
  static const Color surface = Color(0xFF0A0D12);
  static const Color surfaceDim = Color(0xFF090C10);
  static const Color surfaceBright = Color(0xFF37393D);
  static const Color surfaceContainerLowest = Color(0xFF0C0E11);
  static const Color surfaceContainerLow = Color(0xFF11151C);
  static const Color surfaceContainer = Color(0xFF141820);
  static const Color surfaceContainerHigh = Color(0xFF181D26);
  static const Color surfaceContainerHighest = Color(0xFF222834);
  static const Color surfaceCard = Color(0xFF11151C);
  static const Color surfaceLight = Color(0xFF181D26);
  static const Color surfaceElevated = Color(0xFF222834);

  // Glassmorphism & outlines
  static const Color outline = Color(0xFF2E3742);
  static const Color outlineVariant = Color(0xFF1C232D);
  static const Color glass = Color(0x12FFFFFF);
  static const Color glassBorder = Color(0x1FFFFFFF);
  static const Color metallicHairline = Color(0x1FFFFFFF);

  // ═══════════════════════════════════════════════════════════════════════════
  // TEXT & CONTENT COLORS
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color onSurface = Color(0xFFF1F3F7);
  static const Color onSurfaceVariant = Color(0xFF8E9BA2);
  static const Color textPrimary = Color(0xFFF1F3F7);
  static const Color textSecondary = Color(0xFF8E9BA2);
  static const Color textTertiary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF475569);
  static const Color textOnPrimary = Color(0xFF003731);

  // ═══════════════════════════════════════════════════════════════════════════
  // STATUS & ALERT COLORS - Coral Gentle Caution & Green
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color tertiary = Color(0xFFFFCDD1);
  static const Color tertiaryFixedDim = Color(0xFFFB7185);
  static const Color coralGlow = Color(0xFFF43F5E);
  static const Color coralDark = Color(0xFFE11D48);

  static const Color success = Color(0xFF57F1DB);
  static const Color successLight = Color(0xFF68D391);
  static const Color warning = Color(0xFFF6AD55);
  static const Color warningLight = Color(0xFFFBD38D);
  static const Color error = Color(0xFFFB7185);
  static const Color errorLight = Color(0xFFFFCDD1);
  static const Color info = Color(0xFF3CDDC7);

  static const LinearGradient coralGaugeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFB7185), Color(0xFFF43F5E), Color(0xFFE11D48)],
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // SACRED GOLD & AMBER
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color gold = Color(0xFFF0C94E);
  static const Color goldAccent = Color(0xFFF0C94E);
  static const Color goldSparkle = Color(0xFFFCD34D);
  static const Color goldLight = Color(0xFFF6DFA9);

  // ═══════════════════════════════════════════════════════════════════════════
  // SOCIAL APP BRAND COLORS
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color instagram = Color(0xFFE1306C);
  static const Color tiktok = Color(0xFF00F2EA);
  static const Color youtube = Color(0xFFFF0000);
  static const Color facebook = Color(0xFF1877F2);

  // ═══════════════════════════════════════════════════════════════════════════
  // UTILITIES
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color divider = Color(0xFF1C232D);
  static const Color shimmer = Color(0xFF181D26);
  static const Color overlay = Color(0xCC090C10);
  static const Color scrim = Color(0x99000000);

  // ═══════════════════════════════════════════════════════════════════════════
  // LIGHT PALETTE CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color lightBackground = Color(0xFFF6F9F8);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceCard = Color(0xFFFFFFFF);
  static const Color lightSurfaceCardAlt = Color(0xFFF0FDF9);
  static const Color lightSurfaceContainer = Color(0xFFF1F5F9);
  static const Color lightSurfaceElevated = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextTertiary = Color(0xFF94A3B8);
  static const Color lightPrimary = Color(0xFF0D9488);
  static const Color lightPrimaryContainer = Color(0xFF14B8A6);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0x18000000);
}

/// Dynamic Theme Extension for Digital Sanctuary (Dark & Light Mode)
class SanctuaryColors extends ThemeExtension<SanctuaryColors> {
  final bool isDark;
  final Color background;
  final Color surface;
  final Color surfaceCard;
  final Color surfaceCardAlt;
  final Color surfaceContainer;
  final Color surfaceElevated;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color primary;
  final Color primaryContainer;
  final Color onPrimary;
  final Color border;
  final Color cardBorder;
  final Color gold;
  final Color accent;
  final Color error;
  final Color coralGlow;
  final Color coralDark;
  final Color headerBg;

  const SanctuaryColors({
    required this.isDark,
    required this.background,
    required this.surface,
    required this.surfaceCard,
    required this.surfaceCardAlt,
    required this.surfaceContainer,
    required this.surfaceElevated,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.primary,
    required this.primaryContainer,
    required this.onPrimary,
    required this.border,
    required this.cardBorder,
    required this.gold,
    required this.accent,
    required this.error,
    required this.coralGlow,
    required this.coralDark,
    required this.headerBg,
  });

  static const SanctuaryColors dark = SanctuaryColors(
    isDark: true,
    background: Color(0xFF080A0C),
    surface: Color(0xFF0C0E12),
    surfaceCard: Color(0xFF15181D),
    surfaceCardAlt: Color(0xFF111418),
    surfaceContainer: Color(0xFF15181D),
    surfaceElevated: Color(0xFF202328),
    textPrimary: Color(0xFFF1F3F7),
    textSecondary: Color(0xFF9CA8A4),
    textTertiary: Color(0xFF64748B),
    primary: Color(0xFF57F1DB),
    primaryContainer: Color(0xFF2DD4BF),
    onPrimary: Color(0xFF003731),
    border: Color(0x1AFFFFFF),
    cardBorder: Color(0x14FFFFFF),
    gold: Color(0xFFF0C94E),
    accent: Color(0xFF9F7AEA),
    error: Color(0xFFFB7185),
    coralGlow: Color(0xFFF43F5E),
    coralDark: Color(0xFFE11D48),
    headerBg: Color(0xD90C0E12),
  );

  static const SanctuaryColors light = SanctuaryColors(
    isDark: false,
    background: Color(0xFFF6F9F8),
    surface: Color(0xFFFFFFFF),
    surfaceCard: Color(0xFFFFFFFF),
    surfaceCardAlt: Color(0xFFF0FDF9),
    surfaceContainer: Color(0xFFF1F5F9),
    surfaceElevated: Color(0xFFE2E8F0),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF475569),
    textTertiary: Color(0xFF94A3B8),
    primary: Color(0xFF0D9488),
    primaryContainer: Color(0xFF14B8A6),
    onPrimary: Color(0xFFFFFFFF),
    border: Color(0x18000000),
    cardBorder: Color(0x12000000),
    gold: Color(0xFFD97706),
    accent: Color(0xFF7C3AED),
    error: Color(0xFFE11D48),
    coralGlow: Color(0xFFE11D48),
    coralDark: Color(0xFFBE123C),
    headerBg: Color(0xEEFFFFFF),
  );

  @override
  ThemeExtension<SanctuaryColors> copyWith({
    bool? isDark,
    Color? background,
    Color? surface,
    Color? surfaceCard,
    Color? surfaceCardAlt,
    Color? surfaceContainer,
    Color? surfaceElevated,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? primary,
    Color? primaryContainer,
    Color? onPrimary,
    Color? border,
    Color? cardBorder,
    Color? gold,
    Color? accent,
    Color? error,
    Color? coralGlow,
    Color? coralDark,
    Color? headerBg,
  }) {
    return SanctuaryColors(
      isDark: isDark ?? this.isDark,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceCard: surfaceCard ?? this.surfaceCard,
      surfaceCardAlt: surfaceCardAlt ?? this.surfaceCardAlt,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      primary: primary ?? this.primary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimary: onPrimary ?? this.onPrimary,
      border: border ?? this.border,
      cardBorder: cardBorder ?? this.cardBorder,
      gold: gold ?? this.gold,
      accent: accent ?? this.accent,
      error: error ?? this.error,
      coralGlow: coralGlow ?? this.coralGlow,
      coralDark: coralDark ?? this.coralDark,
      headerBg: headerBg ?? this.headerBg,
    );
  }

  @override
  ThemeExtension<SanctuaryColors> lerp(
    covariant ThemeExtension<SanctuaryColors>? other,
    double t,
  ) {
    if (other is! SanctuaryColors) return this;
    return SanctuaryColors(
      isDark: t < 0.5 ? isDark : other.isDark,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceCard: Color.lerp(surfaceCard, other.surfaceCard, t)!,
      surfaceCardAlt: Color.lerp(surfaceCardAlt, other.surfaceCardAlt, t)!,
      surfaceContainer: Color.lerp(surfaceContainer, other.surfaceContainer, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryContainer: Color.lerp(primaryContainer, other.primaryContainer, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      border: Color.lerp(border, other.border, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      error: Color.lerp(error, other.error, t)!,
      coralGlow: Color.lerp(coralGlow, other.coralGlow, t)!,
      coralDark: Color.lerp(coralDark, other.coralDark, t)!,
      headerBg: Color.lerp(headerBg, other.headerBg, t)!,
    );
  }

  static SanctuaryColors of(BuildContext context) {
    return Theme.of(context).extension<SanctuaryColors>() ??
        (Theme.of(context).brightness == Brightness.dark
            ? SanctuaryColors.dark
            : SanctuaryColors.light);
  }
}

extension SanctuaryThemeContext on BuildContext {
  SanctuaryColors get sanctuary => SanctuaryColors.of(this);
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}

