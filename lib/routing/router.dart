/// Navigation configuration built on `go_router`.
library;

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/repositories/settings/settings_repository.dart';
import '../ui/home/view_models/home_viewmodel.dart';
import '../ui/home/widgets/home_screen.dart';
import '../ui/onboarding/view_models/onboarding_viewmodel.dart';
import '../ui/onboarding/widgets/onboarding_screen.dart';
import '../ui/settings/view_models/settings_viewmodel.dart';
import '../ui/settings/widgets/settings_screen.dart';
import 'routes.dart';

/// Creates the app router.
///
/// Each route creates its view model with a [ChangeNotifierProvider], which
/// also disposes it when the route goes away.
///
/// Until the user finishes the welcome screen, every location redirects to
/// [Routes.welcome]; afterwards [Routes.welcome] redirects home. The router
/// re-evaluates redirects whenever [settingsRepository] changes.
GoRouter router(SettingsRepository settingsRepository) {
  return GoRouter(
    initialLocation: Routes.home,
    refreshListenable: settingsRepository,
    redirect: (context, state) =>
        _redirect(settingsRepository, state.matchedLocation),
    routes: [
      GoRoute(
        path: Routes.home,
        builder: (context, state) => ChangeNotifierProvider(
          create: (context) => HomeViewModel(),
          child: const HomeScreen(),
        ),
        routes: [
          GoRoute(
            path: 'settings',
            builder: (context, state) => ChangeNotifierProvider(
              create: (context) =>
                  SettingsViewModel(settingsRepository: context.read()),
              child: const SettingsScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: Routes.welcome,
        builder: (context, state) => ChangeNotifierProvider(
          create: (context) =>
              OnboardingViewModel(settingsRepository: context.read()),
          child: const OnboardingScreen(),
        ),
      ),
    ],
  );
}

/// Returns where to go instead of [location], or `null` to stay.
String? _redirect(SettingsRepository settingsRepository, String location) {
  final onboarded = settingsRepository.settings.onboardingCompleted;
  final atWelcome = location == Routes.welcome;

  if (!onboarded && !atWelcome) return Routes.welcome;
  if (onboarded && atWelcome) return Routes.home;

  return null;
}
