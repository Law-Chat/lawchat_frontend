import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_links/app_links.dart';

import 'package:lawchat_frontend/features/auth/login_screen.dart';
import 'package:lawchat_frontend/features/auth/register_screen.dart';
import 'package:lawchat_frontend/features/onboarding/onboarding_screen.dart';
import 'package:lawchat_frontend/features/splash/splash_screen.dart';

import 'theme/app_theme.dart';
import 'widgets/nav/app_shell.dart';
import 'features/home/home_page.dart';
import 'features/history/history_page.dart';
import 'features/profile/profile_page.dart';
import 'features/alerts/alerts_page.dart';
import 'models/chat_models.dart';
import 'features/law/law_detail_page.dart';
import 'features/chatting/chatting_page.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final isLoggedIn = await AuthService.instance.isLoggedIn();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSub;

  @override
  void initState() {
    super.initState();
    _setupRouter();
    _initDeepLinks();
  }

  @override
  void dispose() {
    _linkSub?.cancel();
    super.dispose();
  }

  void _handleIncomingUri(Uri uri) async {
    debugPrint('incoming uri: $uri');

    if (uri.scheme == 'lawchat' && uri.host == 'callback') {
      final token = uri.queryParameters['token'];
      final isNewUser = uri.queryParameters['isNewUser'] == 'true';

      if (token != null && token.isNotEmpty) {
        await AuthService.instance.saveToken(token);

        if (isNewUser) {
          _router.go('/register');
        } else {
          _router.go('/home');
        }
      }
    }
  }

  void _initDeepLinks() {
    _appLinks = AppLinks();

    _linkSub = _appLinks.uriLinkStream.listen(
      (Uri? uri) {
        if (uri == null) return;
        _handleIncomingUri(uri);
      },
      onError: (err) {
        debugPrint('link stream error: $err');
      },
    );
  }

  void _setupRouter() {
    _router = GoRouter(
      initialLocation: widget.isLoggedIn ? '/home' : '/',
      routes: [
        GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
        GoRoute(
          path: '/onboarding',
          builder: (_, __) => const OnboardingScreen(),
        ),
        GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
        GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
        ShellRoute(
          builder: (_, __, child) => AppShell(child: child),
          routes: [
            GoRoute(path: '/home', builder: (_, __) => const HomePage()),
            GoRoute(path: '/history', builder: (_, __) => const HistoryPage()),
            GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),
            GoRoute(path: '/alerts', builder: (_, __) => const AlertsPage()),
          ],
        ),
        GoRoute(
          path: '/chatting',
          builder: (_, state) {
            final extra = state.extra;
            if (extra is ChatThread) {
              return ChattingPage(thread: extra);
            }
            return const ChattingPage();
          },
        ),
        GoRoute(path: '/law/detail', builder: (_, __) => const LawDetailPage()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Law Chat',
      theme: buildLightTheme(),
      locale: const Locale('ko', 'KR'),
      supportedLocales: const [Locale('ko', 'KR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
