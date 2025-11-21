import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lawchat_frontend/theme/colors.dart';
import 'package:lawchat_frontend/ui/components/button.dart';
import 'package:lawchat_frontend/ui/components/input.dart';
import 'package:lawchat_frontend/ui/components/checkbox.dart';
import 'package:lawchat_frontend/ui/components/modal.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:lawchat_frontend/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  bool _termsAgreed = false;
  bool _privacyAgreed = false;

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {}));
    _emailController.addListener(() => setState(() {}));

    _fetchCurrentUser();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _fetchCurrentUser() async {
    try {
      final token = await AuthService.instance.getToken();
      if (token == null || token.isEmpty) {
        setState(() {
          _errorMessage = '저장된 토큰이 없습니다.';
          _isLoading = false;
        });
        return;
      }

      final baseUrl = dotenv.env['BASE_URL'] ?? '';
      final dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final response = await dio.get('/api/auth/me');
      final data = response.data as Map<String, dynamic>;

      setState(() {
        _nameController.text = data['name'] ?? '';
        _emailController.text = data['email'] ?? '';
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('[ERROR] /api/auth/me : $e');
      setState(() {
        _errorMessage = '사용자 정보를 불러오지 못했습니다.';
        _isLoading = false;
      });
    }
  }

  void _showTermsModal(String title, String content) {
    AppModal.show(
      context: context,
      title: title,
      child: SingleChildScrollView(child: Text(content)),
    );
  }

  void _onSubmit() {
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final textButtonStyle = TextButton.styleFrom(
      splashFactory: NoSplash.splashFactory,
      shadowColor: Colors.transparent,
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ).copyWith(overlayColor: MaterialStateProperty.all(Colors.transparent));

    final isButtonEnabled =
        _termsAgreed &&
        _privacyAgreed &&
        _nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '회원가입',
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (_errorMessage != null) ...[
                    Text(
                      _errorMessage!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.error,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  const SizedBox(height: 32),
                  AppInput(
                    variant: AppInputVariant.disabledWithIcon,
                    controller: _nameController,
                    hintText: 'Gildong Hong',
                    leading: LucideIcons.user,
                  ),
                  const SizedBox(height: 16),
                  AppInput(
                    variant: AppInputVariant.disabledWithIcon,
                    controller: _emailController,
                    hintText: 'example@gmail.com',
                    leading: LucideIcons.mail,
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: AppColors.disable, height: 16),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      AppCheckbox(
                        value: _termsAgreed,
                        onChanged: (value) =>
                            setState(() => _termsAgreed = value),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        style: textButtonStyle,
                        onPressed: () =>
                            _showTermsModal('이용약관', '이용약관 내용입니다...'),
                        child: const Text(
                          '이용약관',
                          style: TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const Text(
                        ' 동의',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.disable,
                        ),
                      ),
                      const Text(
                        ' *',
                        style: TextStyle(fontSize: 14, color: AppColors.error),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      AppCheckbox(
                        value: _privacyAgreed,
                        onChanged: (value) =>
                            setState(() => _privacyAgreed = value),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        style: textButtonStyle,
                        onPressed: () => _showTermsModal(
                          'LawChat 개인정보 수집 및 이용',
                          '개인정보 수집 및 이용 내용입니다...',
                        ),
                        child: const Text(
                          'LawChat 개인정보 수집 및 이용',
                          style: TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const Text(
                        ' 동의',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.disable,
                        ),
                      ),
                      const Text(
                        ' *',
                        style: TextStyle(fontSize: 14, color: AppColors.error),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  AppButton(
                    variant: AppButtonVariant.primary,
                    label: '가입하기',
                    onPressed: isButtonEnabled ? _onSubmit : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '이미 계정이 있으신가요? ',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.disable,
                        ),
                      ),
                      TextButton(
                        style: textButtonStyle,
                        onPressed: () => context.go('/login'),
                        child: const Text(
                          '로그인',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
