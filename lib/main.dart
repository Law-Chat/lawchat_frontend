import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lawchat_frontend/features/onboarding/onboarding_screen.dart';
import 'package:lawchat_frontend/features/splash/splash_screen.dart';

import 'theme/app_theme.dart';
import 'widgets/nav/app_shell.dart';

import 'features/home/home_page.dart';
import 'features/history/history_page.dart';
import 'features/profile/profile_page.dart';
import 'features/alerts/alerts_page.dart';
import 'features/chatting/chatting_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        ShellRoute(
          builder: (context, state, child) => AppShell(child: child),
          routes: [
            GoRoute(path: '/home', builder: (_, __) => const HomePage()),
            GoRoute(path: '/history', builder: (_, __) => const HistoryPage()),
            GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),
            GoRoute(path: '/alerts', builder: (_, __) => const AlertsPage()),
          ],
        ),

        // FAB 단독 페이지
        GoRoute(path: '/chatting', builder: (_, __) => const ChattingPage()),
      ],
    );

    return MaterialApp.router(
      title: 'Law Chat',
      theme: buildLightTheme(),
      routerConfig: router,
    );
  }
}
