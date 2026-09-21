import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../providers/providers.dart';
import '../../../router.dart';

class _Dhikr {
  final String id;
  final String name;
  final String arabic;
  final String pronunciation;
  final String meaning;
  const _Dhikr(
    this.id,
    this.name,
    this.arabic,
    this.pronunciation,
    this.meaning,
  );
}

const _phrases = [
  _Dhikr(
    'istighfar',
    'Seeking forgiveness',
    'أَسْتَغْفِرُ اللّٰهَ وَأَتُوبُ إِلَيْهِ',
    'Astaghfirullah wa atoobu ilayh',
    'I seek forgiveness from Allah and repent to Him',
  ),
  _Dhikr(
    'tasbih',
    'Tasbih',
    'سُبْحَانَ اللّٰهِ وَبِحَمْدِهِ',
    'SubhanAllah wa bihamdihi',
    'Glory be to Allah and praise be to Him',
  ),
  _Dhikr(
    'salawat',
    'Sending blessings',
    'اللّٰهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ',
    "Allahumma salli wa sallim 'ala nabiyyina Muhammad",
    'Send peace and blessings upon our Prophet Muhammad',
  ),
];

class DhikrExercise extends ConsumerStatefulWidget {
  const DhikrExercise({super.key});
  @override
  ConsumerState<DhikrExercise> createState() => _DhikrExerciseState();
}

class _DhikrExerciseState extends ConsumerState<DhikrExercise> {
  int _index = 0;
  int _target = 33;
  final _sessionCounts = List<int>.filled(_phrases.length, 0);
  List<int> _todayCounts = List<int>.filled(_phrases.length, 0);
  int _todayTotal = 0;
  SharedPreferences? _prefs;
  String? _loadedDay;

  String get _day {
    final now = DateTime.now();
    return 'dhikr_taps_${now.year}_${now.month}_${now.day}';
  }

  String _key(String day, int index) => '${day}_${_phrases[index].id}';

  @override
  void initState() {
    super.initState();
    _index = DateTime.now().day % _phrases.length;
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final day = _day;
    final counts = List.generate(
      _phrases.length,
      (i) => prefs.getInt(_key(day, i)) ?? 0,
    );
    setState(() {
      _prefs = prefs;
      _loadedDay = day;
      _todayCounts = counts;
      _todayTotal = math.max(
        prefs.getInt(day) ?? 0,
        counts.fold<int>(0, (sum, value) => sum + value),
      );
    });
    ref.read(dhikrCountProvider.notifier).updateCount(_todayTotal);
  }

  Future<void> _count() async {
    _prefs ??= await SharedPreferences.getInstance();
    if (!mounted) return;
    final prefs = _prefs!;
    final day = _day;
    if (_loadedDay != day) {
      _loadedDay = day;
      _todayCounts = List.generate(
        _phrases.length,
        (i) => prefs.getInt(_key(day, i)) ?? 0,
      );
      _todayTotal = prefs.getInt(day) ?? 0;
      for (var i = 0; i < _sessionCounts.length; i++) {
        _sessionCounts[i] = 0;
      }
    }
    if (ref.read(settingsProvider).valueOrNull?.hapticsEnabled ?? true) {
      HapticFeedback.lightImpact();
    }
    setState(() {
      _sessionCounts[_index]++;
      _todayCounts[_index]++;
      _todayTotal++;
    });
    await prefs.setInt(_key(day, _index), _todayCounts[_index]);
    await prefs.setInt(day, _todayTotal);
    ref.read(dhikrCountProvider.notifier).updateCount(_todayTotal);
  }

  void _reset() {
    if (ref.read(settingsProvider).valueOrNull?.hapticsEnabled ?? true) {
      HapticFeedback.selectionClick();
    }
    setState(() => _sessionCounts[_index] = 0);
  }

  void _next() {
    if (ref.read(settingsProvider).valueOrNull?.hapticsEnabled ?? true) {
      HapticFeedback.selectionClick();
    }
    setState(() => _index = (_index + 1) % _phrases.length);
  }

  void _exit() {
    if (_sessionCounts.any((value) => value > 0)) {
      ref.read(usageProvider.notifier).incrementIntervention();
      ref.read(usageProvider.notifier).startSession();
    }
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.sanctuary;
    final phrase = _phrases[_index];
    final count = _sessionCounts[_index];
    return Scaffold(
      backgroundColor: colors.background,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: SizedBox(
            height: 54,
            child: FilledButton.icon(
              onPressed: _next,
              icon: const Icon(Icons.autorenew_rounded),
              label: const Text('Another Dhikr'),
              style: FilledButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _exit,
                    tooltip: 'Back',
                    icon: const Icon(Icons.arrow_back_rounded),
                    color: colors.textPrimary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Dhikr',
                    style: AppTypography.titleLarge.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Column(
                      children: [
                        _header(colors, phrase),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            SizedBox(
                              width: 48,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton.filledTonal(
                                    onPressed: _reset,
                                    tooltip: 'Reset current count',
                                    icon: Icon(
                                      Icons.restart_alt_rounded,
                                      color: colors.primary,
                                    ),
                                  ),
                                  Text(
                                    'Reset',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: colors.textSecondary,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(child: _beadCircle(colors, phrase, count)),
                            const SizedBox(width: 48),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Tap the circle after each recitation',
                          textAlign: TextAlign.center,
                          style: AppTypography.bodySmall.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 28),
                        Row(
                          children: [
                            Expanded(
                              child: _metric(
                                colors,
                                'Target',
                                '$_target',
                                Icons.track_changes_rounded,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _metric(
                                colors,
                                'This Dhikr today',
                                '${_todayCounts[_index]}',
                                Icons.grain_rounded,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _metric(
                                colors,
                                'All today',
                                '$_todayTotal',
                                Icons.favorite_outline_rounded,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          phrase.meaning,
                          textAlign: TextAlign.center,
                          style: AppTypography.bodySmall.copyWith(
                            color: colors.textSecondary,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(SanctuaryColors colors, _Dhikr phrase) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
    decoration: BoxDecoration(
      color: colors.surfaceCard,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: colors.border),
    ),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: colors.primary.withValues(alpha: 0.12),
          child: Icon(Icons.grain_rounded, color: colors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                phrase.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.titleMedium.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                phrase.pronunciation,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodySmall.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        PopupMenuButton<int>(
          tooltip: 'Choose recitation target',
          initialValue: _target,
          onSelected: (value) => setState(() => _target = value),
          itemBuilder: (_) => const [
            PopupMenuItem(value: 33, child: Text('33 recitations')),
            PopupMenuItem(value: 99, child: Text('99 recitations')),
          ],
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$_target',
                  style: AppTypography.labelLarge.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: colors.primary,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  Widget _beadCircle(SanctuaryColors colors, _Dhikr phrase, int count) {
    return Semantics(
      button: true,
      label: '${phrase.name}: $count recitations. Tap to count.',
      child: GestureDetector(
        key: const ValueKey('dhikr_counter_button'),
        onTap: _count,
        child: AspectRatio(
          aspectRatio: 1,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = constraints.maxWidth;
              final beadSize = size < 210 ? 5.0 : 7.0;
              final radius = size * 0.43;
              final remainder = count % _target;
              final progress = count > 0 && remainder == 0
                  ? _target
                  : remainder;
              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: size * 0.85,
                    height: size * 0.85,
                    decoration: BoxDecoration(
                      color: colors.surfaceCard,
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.border),
                      boxShadow: [
                        BoxShadow(
                          color: colors.primary.withValues(alpha: 0.10),
                          blurRadius: 26,
                        ),
                      ],
                    ),
                  ),
                  ...List.generate(33, (index) {
                    final angle = -math.pi / 2 + 2 * math.pi * index / 33;
                    final active = index < (progress / _target * 33).ceil();
                    return Positioned(
                      left: size / 2 + radius * math.cos(angle) - beadSize / 2,
                      top: size / 2 + radius * math.sin(angle) - beadSize / 2,
                      child: Container(
                        width: beadSize,
                        height: beadSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: active
                              ? colors.primary
                              : colors.primary.withValues(alpha: 0.12),
                          border: Border.all(
                            color: colors.primary.withValues(alpha: 0.2),
                          ),
                        ),
                      ),
                    );
                  }),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: size * 0.12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          phrase.arabic,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          maxLines: 3,
                          style: GoogleFonts.amiri(
                            color: colors.primary,
                            fontSize: size < 210 ? 19 : 23,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '$count / $_target',
                          style: AppTypography.titleSmall.copyWith(
                            color: colors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _metric(
    SanctuaryColors colors,
    String label,
    String value,
    IconData icon,
  ) => Container(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
    decoration: BoxDecoration(
      color: colors.surfaceCard,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: colors.border),
    ),
    child: Column(
      children: [
        Icon(icon, size: 17, color: colors.primary),
        const SizedBox(height: 5),
        Text(
          value,
          style: AppTypography.titleMedium.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.labelSmall.copyWith(
            color: colors.textSecondary,
            fontSize: 10,
          ),
        ),
      ],
    ),
  );
}
