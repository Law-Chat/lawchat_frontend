import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syncfusion_flutter_core/localizations.dart';
import 'package:go_router/go_router.dart';

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
      routes: [
        ShellRoute(
          builder: (context, state, child) => AppShell(child: child),
          routes: [
            GoRoute(path: '/', redirect: (_, __) => '/home'),
            GoRoute(path: '/home', builder: (_, __) => const HomePage()),
            GoRoute(path: '/history', builder: (_, __) => const HistoryPage()),
            GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),
            GoRoute(path: '/alerts', builder: (_, __) => const AlertsPage()),
          ],
        ),
        GoRoute(path: '/chatting', builder: (_, __) => const ChattingPage()),
      ],
    );

    return MaterialApp.router(
      title: 'Law Chat',
      theme: buildLightTheme(),
      routerConfig: router,
      locale: const Locale('ko', 'KR'),
      supportedLocales: const [Locale('ko', 'KR')],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
