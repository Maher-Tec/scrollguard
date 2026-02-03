import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/onboarding/screens/welcome_screen.dart';
import 'features/onboarding/screens/intro_video_screen.dart';
import 'features/onboarding/screens/app_selection_screen.dart';
import 'features/onboarding/screens/permission_screen.dart';
import 'features/dashboard/screens/dashboard_screen.dart';
import 'features/settings/screens/settings_screen.dart';
import 'features/intervention/screens/intervention_screen.dart';
import 'features/intervention/screens/breathing_exercise.dart';
import 'providers/providers.dart';

// ═══════════════════════════════════════════════════════════════════════════
// ROUTE NAMES
// ═══════════════════════════════════════════════════════════════════════════

class Routes {
  static const intro = '/intro';
  static const welcome = '/';
  static const appSelection = '/onboarding/apps';
  static const permissions = '/onboarding/permissions';
  static const dashboard = '/dashboard';
  static const settings = '/settings';
  static const intervention = '/intervention';
  static const breathing = '/intervention/breathing';
}

// ═══════════════════════════════════════════════════════════════════════════
// ROUTER PROVIDER
// ═══════════════════════════════════════════════════════════════════════════

final routerProvider = Provider<GoRouter>((ref) {
  // Don't watch settings - just read it once for initial redirect
  // This prevents constant re-renders during onboarding
  
  return GoRouter(
    initialLocation: Routes.intro,
    redirect: (context, state) {
      // Read settings synchronously - don't watch
      final container = ProviderScope.containerOf(context);
      final settings = container.read(settingsProvider);
      final settingsValue = settings.valueOrNull;
      
      // Still loading settings - don't redirect
      if (settingsValue == null) {
        return null;
      }
      
      final isOnIntro = state.matchedLocation == Routes.intro;
      final isOnWelcome = state.matchedLocation == Routes.welcome;
      final isOnDashboard = state.matchedLocation == Routes.dashboard ||
                            state.matchedLocation == Routes.settings ||
                            state.matchedLocation == Routes.intervention ||
                            state.matchedLocation == Routes.breathing;
      
      // If onboarding complete, go to dashboard (skip intro/welcome)
      if (settingsValue.onboardingComplete) {
        if (isOnIntro || isOnWelcome) {
          return Routes.dashboard;
        }
      }
      
      // If onboarding NOT complete and trying to access dashboard, go to intro
      if (!settingsValue.onboardingComplete && isOnDashboard) {
        return Routes.intro;
      }
      
      return null;
    },
    routes: [
      // ═══════════════════════════════════════════════════════════════════════
      // ONBOARDING ROUTES
      // ═══════════════════════════════════════════════════════════════════════
      
      GoRoute(
        path: Routes.intro,
        pageBuilder: (context, state) => _fadeTransition(
          state,
          const IntroVideoScreen(),
        ),
      ),
      GoRoute(
        path: Routes.welcome,
        pageBuilder: (context, state) => _fadeTransition(
          state,
          const WelcomeScreen(),
        ),
      ),
      GoRoute(
        path: Routes.appSelection,
        pageBuilder: (context, state) => _slideTransition(
          state,
          const AppSelectionScreen(),
        ),
      ),
      GoRoute(
        path: Routes.permissions,
        pageBuilder: (context, state) => _slideTransition(
          state,
          const PermissionScreen(),
        ),
      ),
      
      // ═══════════════════════════════════════════════════════════════════════
      // MAIN APP ROUTES
      // ═══════════════════════════════════════════════════════════════════════
      
      GoRoute(
        path: Routes.dashboard,
        pageBuilder: (context, state) => _fadeTransition(
          state,
          const DashboardScreen(),
        ),
      ),
      GoRoute(
        path: Routes.settings,
        pageBuilder: (context, state) => _slideTransition(
          state,
          const SettingsScreen(),
          slideFromBottom: true,
        ),
      ),
      
      // ═══════════════════════════════════════════════════════════════════════
      // INTERVENTION ROUTES
      // ═══════════════════════════════════════════════════════════════════════
      
      GoRoute(
        path: Routes.intervention,
        pageBuilder: (context, state) => _fadeTransition(
          state,
          const InterventionScreen(),
          duration: const Duration(milliseconds: 800),
        ),
      ),
      GoRoute(
        path: Routes.breathing,
        pageBuilder: (context, state) => _fadeTransition(
          state,
          const BreathingExercise(),
          duration: const Duration(milliseconds: 600),
        ),
      ),
    ],
  );
});

// ═══════════════════════════════════════════════════════════════════════════
// PAGE TRANSITIONS
// ═══════════════════════════════════════════════════════════════════════════

CustomTransitionPage<void> _fadeTransition(
  GoRouterState state,
  Widget child, {
  Duration duration = const Duration(milliseconds: 350),
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ),
        child: child,
      );
    },
  );
}

CustomTransitionPage<void> _slideTransition(
  GoRouterState state,
  Widget child, {
  bool slideFromBottom = false,
  Duration duration = const Duration(milliseconds: 350),
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final begin = slideFromBottom 
          ? const Offset(0, 1) 
          : const Offset(1, 0);
      
      final slideAnimation = Tween<Offset>(
        begin: begin,
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      ));

      final fadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ));

      return SlideTransition(
        position: slideAnimation,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: child,
        ),
      );
    },
  );
}
