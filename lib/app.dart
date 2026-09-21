import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/app_colors.dart';
import 'router.dart';
import 'providers/providers.dart';

class ScrollGuardApp extends ConsumerStatefulWidget {
  const ScrollGuardApp({super.key});

  @override
  ConsumerState<ScrollGuardApp> createState() => _ScrollGuardAppState();
}

class _ScrollGuardAppState extends ConsumerState<ScrollGuardApp> {
  static const _navigationChannel = MethodChannel('com.maherahmed.scrollguard/navigation');
  bool _checkingPendingRoute = false;
  bool _checkPendingRouteAgain = false;
  bool _initialRouteChecked = false;

  @override
  void initState() {
    super.initState();
    _navigationChannel.setMethodCallHandler((call) async {
      if (call.method == 'openRoute' && call.arguments is String) {
        if (ref.read(settingsProvider).valueOrNull != null) {
          await _checkPendingRoute();
        }
      }
    });
  }

  void _openRoute(String route) {
    if (!mounted || ref.read(settingsProvider).valueOrNull == null) return;
    if (route == Routes.intervention) {
      ref.read(routerProvider).go(route);
    }
  }

  Future<void> _checkPendingRoute() async {
    if (_checkingPendingRoute) {
      _checkPendingRouteAgain = true;
      return;
    }
    _checkingPendingRoute = true;
    try {
      final route = await _navigationChannel.invokeMethod<String>('getPendingRoute');
      if (route != null) _openRoute(route);
    } on MissingPluginException {
      // Android-only channel.
    } on PlatformException {
      // Navigation remains available through the app UI.
    } finally {
      _checkingPendingRoute = false;
      if (_checkPendingRouteAgain && mounted) {
        _checkPendingRouteAgain = false;
        _checkPendingRoute();
      }
    }
  }

  @override
  void dispose() {
    _navigationChannel.setMethodCallHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final settings = ref.watch(settingsProvider);
    if (settings.valueOrNull != null && !_initialRouteChecked) {
      _initialRouteChecked = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _checkPendingRoute());
    }

    final themeMode = settings.valueOrNull?.themeMode ?? ThemeMode.dark;

    return MaterialApp.router(
      title: 'ScrollGuard',
      debugShowCheckedModeBanner: false,
      
      // Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      
      // Router
      routerConfig: router,
      
      // Builder for global configurations
      builder: (context, child) {
        // Ensure Google Fonts are cached
        GoogleFonts.config.allowRuntimeFetching = true;
        
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
