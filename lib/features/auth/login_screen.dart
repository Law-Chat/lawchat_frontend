import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                icon: Image.asset(
                  'assets/images/google_logo.png',
                  height: 24.0,
                ), // Assuming you have a google logo asset
                label: const Text('구글 로그인'),
                onPressed: () =>
                    context.go('/register'), // Navigate to register for now
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
