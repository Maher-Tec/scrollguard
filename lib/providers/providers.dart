import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/user_settings.dart';
import '../data/models/usage_entry.dart';
import '../data/repositories/settings_repository.dart';
import '../data/repositories/usage_repository.dart';
import '../data/services/permission_service.dart';
import '../data/services/usage_stats_service.dart';

// ═══════════════════════════════════════════════════════════════════════════
// REPOSITORIES
// ═══════════════════════════════════════════════════════════════════════════

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository();
});

final usageRepositoryProvider = Provider<UsageRepository>((ref) {
  return UsageRepository();
});

// ═══════════════════════════════════════════════════════════════════════════
// SERVICES
// ═══════════════════════════════════════════════════════════════════════════

final permissionServiceProvider = Provider<PermissionService>((ref) {
  return PermissionService();
});

final usageStatsServiceProvider = Provider<UsageStatsService>((ref) {
  return UsageStatsService();
});

// ═══════════════════════════════════════════════════════════════════════════
// SETTINGS STATE
// ═══════════════════════════════════════════════════════════════════════════

final settingsProvider = StateNotifierProvider<SettingsNotifier, AsyncValue<UserSettings>>((ref) {
  return SettingsNotifier(
    ref.read(settingsRepositoryProvider),
    ref.read(usageStatsServiceProvider),
  );
});

class SettingsNotifier extends StateNotifier<AsyncValue<UserSettings>> {
  final SettingsRepository _repository;
  final UsageStatsService _usageService;

  SettingsNotifier(this._repository, this._usageService) : super(const AsyncValue.loading()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    state = const AsyncValue.loading();
    try {
      final settings = await _repository.loadSettings();
      state = AsyncValue.data(settings);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> reload() async {
    await _loadSettings();
  }

  Future<void> updateSettings(UserSettings settings) async {
    await _repository.saveSettings(settings);
    state = AsyncValue.data(settings);
  }

  Future<void> completeOnboarding() async {
    final current = state.valueOrNull;
    if (current != null) {
      final updated = current.copyWith(onboardingComplete: true);
      await _repository.saveSettings(updated);
      state = AsyncValue.data(updated);
    }
  }

  Future<void> toggleApp(String packageName, bool enabled) async {
    final current = state.valueOrNull;
    if (current != null) {
      final updatedApps = current.monitoredApps.map((app) {
        if (app.packageName == packageName) {
          return app.copyWith(isEnabled: enabled);
        }
        return app;
      }).toList();
      
      final updated = current.copyWith(monitoredApps: updatedApps);
      await _repository.saveSettings(updated);
      state = AsyncValue.data(updated);
    }
  }

  Future<void> setTimeLimit(int minutes) async {
    final current = state.valueOrNull;
    if (current != null) {
      final updated = current.copyWith(timeLimitMinutes: minutes);
      await _repository.saveSettings(updated);
      state = AsyncValue.data(updated);
    }
  }

  Future<void> toggleHaptics(bool enabled) async {
    final current = state.valueOrNull;
    if (current != null) {
      final updated = current.copyWith(hapticsEnabled: enabled);
      await _repository.saveSettings(updated);
      state = AsyncValue.data(updated);
    }
  }

  Future<void> toggleSounds(bool enabled) async {
    final current = state.valueOrNull;
    if (current != null) {
      final updated = current.copyWith(soundsEnabled: enabled);
      await _repository.saveSettings(updated);
      state = AsyncValue.data(updated);
    }
  }

  Future<void> toggleMonitoring(bool active) async {
    final current = state.valueOrNull;
    if (current != null) {
      final updated = current.copyWith(monitoringActive: active);
      await _repository.saveSettings(updated);
      state = AsyncValue.data(updated);
      
      if (!active) {
         await _usageService.stopMonitoring();
      }
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// USAGE STATE
// ═══════════════════════════════════════════════════════════════════════════

final usageProvider = StateNotifierProvider<UsageNotifier, AsyncValue<DailyUsage>>((ref) {
  return UsageNotifier(
    ref.read(usageRepositoryProvider),
    ref.read(usageStatsServiceProvider),
    ref.read(settingsRepositoryProvider),
  );
});

class UsageNotifier extends StateNotifier<AsyncValue<DailyUsage>> {
  final UsageRepository _repository;
  final UsageStatsService _usageService;
  final SettingsRepository _settingsRepository;

  UsageNotifier(
    this._repository, 
    this._usageService,
    this._settingsRepository,
  ) : super(const AsyncValue.loading()) {
    _loadUsage();
  }

  Future<void> _loadUsage() async {
    state = const AsyncValue.loading();
    try {
      // 1. Load local data (preserves intervention count)
      final localUsage = await _repository.getTodayUsage();
      
      // 2. Load settings to know which apps to check
      final settings = await _settingsRepository.loadSettings();
      final packageNames = settings.enabledPackages;

      // 3. Fetch actual usage from Native Android layer
      final nativeUsageMap = packageNames.isNotEmpty 
          ? await _usageService.getTodayUsage(packageNames)
          : <String, int>{};

      // 4. Fetch Baseline (usage at start of session)
      final baselineMap = await _repository.getBaseline();

      // 5. Calculate Effective Usage (Current - Baseline)
      int totalMinutes = 0;
      final effectiveUsageMap = <String, int>{};

      for (final entry in nativeUsageMap.entries) {
        final pkg = entry.key;
        final currentMinutes = entry.value;
        final baselineMinutes = baselineMap[pkg] ?? 0;
        
        // Ensure strictly non-negative usage for the session
        final sessionMinutes = (currentMinutes - baselineMinutes).clamp(0, 9999);
        
        effectiveUsageMap[pkg] = sessionMinutes;
        totalMinutes += sessionMinutes;
      }
      
      final updatedUsage = localUsage.copyWith(
        totalMinutes: totalMinutes,
        appUsage: effectiveUsageMap,
      );

      // 6. Save back to local repo
      await _repository.saveTodayUsage(updatedUsage);

      // 7. Sync with Native monitoring if active
      if (settings.monitoringActive && packageNames.isNotEmpty) {
        await _usageService.startMonitoring(
          packageNames: packageNames,
          timeLimitMinutes: settings.timeLimitMinutes,
          baselines: effectiveUsageMap,
        );
      }

      state = AsyncValue.data(updatedUsage);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> reload() async {
    await _loadUsage();
  }
  
  /// Start a new session: resets the daily counter to 0 by setting current usage as baseline
  Future<void> startSession() async {
    try {
      final settings = await _settingsRepository.loadSettings();
      final packageNames = settings.enabledPackages;
      
      if (packageNames.isNotEmpty) {
        // Snapshot current usage as the new baseline
        final currentUsage = await _usageService.getTodayUsage(packageNames);
        await _repository.saveBaseline(currentUsage);
        
        // Reload to reflect 0 usage
        await _loadUsage();
      }
    } catch (e) {
      // Ignore errors manually
    }
  }

  Future<void> addUsage({
    required String packageName,
    required String appName,
    required int minutes,
  }) async {
    // For manual testing/simulation. In prod, we rely on native sync.
    final updated = await _repository.addUsageTime(
      packageName: packageName,
      appName: appName,
      minutes: minutes,
    );
    state = AsyncValue.data(updated);
  }

  Future<void> incrementIntervention() async {
    final current = state.valueOrNull;
    if (current != null) {
      await _repository.incrementInterventionCount();
      final updated = current.copyWith(
        interventionCount: current.interventionCount + 1,
      );
      state = AsyncValue.data(updated);
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PERMISSION STATE
// ═══════════════════════════════════════════════════════════════════════════

final permissionStatusProvider = FutureProvider<PermissionStatus>((ref) async {
  final service = ref.read(permissionServiceProvider);
  return service.getPermissionStatus();
});
