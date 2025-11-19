import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> _loginWithGoogle() async {
    final baseUrl = dotenv.env['BASE_URL'] ?? '';

    const redirectUri = 'lawchat://auth/callback';

    final oauthUrl =
        '$baseUrl/oauth2/authorization/google'
        '?redirect_uri=$redirectUri';

    final url = Uri.parse(oauthUrl);

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('OAuth URL launch failed: $oauthUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/icon.png', width: 140, height: 140),
              const SizedBox(height: 20),
              const Text('Welcome to', style: TextStyle(fontSize: 32)),
              const Text(
                'LawChat',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 100),
              ElevatedButton.icon(
                icon: Image.asset('assets/images/google_logo.png', height: 24),
                label: const Text('구글 로그인'),
                onPressed: _loginWithGoogle,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
