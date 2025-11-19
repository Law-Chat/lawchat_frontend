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
import 'features/chatting/chatting_page.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
    _setupRouter(); // 1) 라우터 먼저 세팅
    _initDeepLinks(); // 2) 딥링크 리스너 등록
    _checkInitialLogin(); // 3) 토큰 있으면 /home으로 이동
  }

  @override
  void dispose() {
    _linkSub?.cancel();
    super.dispose();
  }

  // 처음 앱 켰을 때 로그인 상태라면 /home으로 보내기
  Future<void> _checkInitialLogin() async {
    final isLoggedIn = await AuthService.instance.isLoggedIn();
    if (isLoggedIn) {
      _router.go('/home');
    }
  }

  // 딥링크 처리
  void _handleIncomingUri(Uri uri) async {
    debugPrint('incoming uri: $uri');

    if (uri.scheme == 'lawchat' &&
        uri.host == 'auth' &&
        uri.path == '/callback') {
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

  // app_links 기반 딥링크 리스너
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
      initialLocation: '/',
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
        GoRoute(path: '/chatting', builder: (_, __) => const ChattingPage()),
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
