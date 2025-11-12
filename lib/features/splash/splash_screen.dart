import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _iconAnimationController;
  late Animation<double> _iconShakeAnimation;

  late AnimationController _logoAnimationController;
  late Animation<double> _logoAnimation;

  bool _showLogo = false;

  @override
  void initState() {
    super.initState();

    _iconAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _iconShakeAnimation =
        TweenSequence<double>([
            TweenSequenceItem(
              tween: Tween(begin: 0.0, end: -pi / 18),
              weight: 1,
            ),
            TweenSequenceItem(
              tween: Tween(begin: -pi / 18, end: pi / 18),
              weight: 2,
            ),
            TweenSequenceItem(
              tween: Tween(begin: pi / 18, end: -pi / 36),
              weight: 2,
            ),
            TweenSequenceItem(
              tween: Tween(begin: -pi / 36, end: pi / 36),
              weight: 2,
            ),
            TweenSequenceItem(
              tween: Tween(begin: pi / 36, end: 0.0),
              weight: 1,
            ),
          ]).animate(
            CurvedAnimation(
              parent: _iconAnimationController,
              curve: Curves.elasticOut,
            ),
          )
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted) {
                  setState(() {
                    _showLogo = true;
                  });
                  _logoAnimationController.forward();
                }
              });
            }
          });

    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _logoAnimation =
        CurvedAnimation(parent: _logoAnimationController, curve: Curves.easeIn)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              Future.delayed(const Duration(seconds: 1), () {
                if (mounted) {
                  context.go('/onboarding');
                }
              });
            }
          });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        _iconAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    _logoAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _showLogo
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _logoAnimation,
                    builder: (context, child) {
                      final position = _logoAnimation.value;
                      const softness = 0.5;
                      final start = position * (1 + softness) - softness;
                      final end = start + softness;

                      return ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            colors: const [Colors.black, Colors.transparent],
                            stops: [max(0.0, start), min(1.0, end)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ).createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                          );
                        },
                        blendMode: BlendMode.dstIn,
                        child: child,
                      );
                    },
                    child: SizedBox(
                      width: 240,
                      child: Image.asset('assets/images/logo.png'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Version 1.0'),
                ],
              )
            : AnimatedBuilder(
                animation: _iconShakeAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _iconShakeAnimation.value,
                    child: child,
                  );
                },
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: Image.asset('assets/images/icon.png'),
                ),
              ),
      ),
    );
  }
}
