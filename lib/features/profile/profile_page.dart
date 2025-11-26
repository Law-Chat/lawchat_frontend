import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:lawchat_frontend/services/auth_service.dart';
import 'package:lawchat_frontend/theme/colors.dart';
import 'package:lawchat_frontend/ui/components/toggle.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;
  String? _errorMessage;

  bool _pushNotifications = false;
  bool _legalNotifications = false;
  bool _adEmails = false;

  String _name = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadPageData();
  }

  Future<void> _loadPageData() async {
    await _loadUser();
    await _fetchNotificationSettings();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadUser() async {
    final user = await AuthService.instance.getUser();
    if (mounted) {
      setState(() {
        _name = user['name'] ?? '사용자';
        _email = user['email'] ?? '이메일 정보 없음';
      });
    }
  }

  Future<void> _fetchNotificationSettings() async {
    try {
      final token = await AuthService.instance.getToken();
      if (token == null) throw Exception('Token not found');

      final dio = Dio(
        BaseOptions(
          baseUrl: dotenv.env['BASE_URL'] ?? '',
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final response = await dio.get('/api/users/notification-agreements');
      final data = response.data;

      if (mounted) {
        setState(() {
          _pushNotifications = data['isPushEnabled'] ?? false;
          _legalNotifications = data['isLawRevisionEnabled'] ?? false;
          _adEmails = data['isMarketingEmailEnabled'] ?? false;
        });
      }
    } catch (e) {
      debugPrint('Failed to fetch notification settings: $e');
      if (mounted) {
        setState(() {
          _errorMessage = '알림 설정을 불러오지 못했습니다.';
        });
      }
    }
  }

  Future<void> _logout() async {
    await AuthService.instance.clearToken();
    await AuthService.instance.clearUser();
    if (mounted) context.go('/login');
  }

  Future<void> _updateNotificationSettings() async {
    try {
      final token = await AuthService.instance.getToken();
      if (token == null) throw Exception('Token not found');

      final dio = Dio(
        BaseOptions(
          baseUrl: dotenv.env['BASE_URL'] ?? '',
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final data = {
        'isPushEnabled': _pushNotifications,
        'isLawRevisionEnabled': _legalNotifications,
        'isMarketingEmailEnabled': _adEmails,
      };

      await dio.patch('/api/users/notification-agreements', data: data);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('알림 설정이 저장되었습니다.')));
      }
    } catch (e) {
      debugPrint('Failed to update notification settings: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('설정 저장에 실패했습니다. 다시 시도해주세요.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text('프로필'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildSettingsList(),
    );
  }

  Widget _buildSettingsList() {
    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        const SizedBox(height: 20),
        const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
        const SizedBox(height: 16),
        Text(
          _name,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          _email,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 40),
        _buildSectionHeader('알림 설정'),
        _buildSettingsCard([
          _buildToggleRow('푸시 알림 수신 여부', _pushNotifications, (value) {
            setState(() => _pushNotifications = value);
            _updateNotificationSettings();
          }),
          _buildToggleRow('계정 법령 알림 여부', _legalNotifications, (value) {
            setState(() => _legalNotifications = value);
            _updateNotificationSettings();
          }),
          _buildToggleRow('광고성 이메일 수신 여부', _adEmails, (value) {
            setState(() => _adEmails = value);
            _updateNotificationSettings();
          }),
        ]),
        const SizedBox(height: 30),
        _buildSectionHeader('계정 설정'),
        _buildSettingsCard([
          _buildTextButtonRow('로그아웃', _logout),
          _buildTextButtonRow('서비스 탈퇴', _logout, isDestructive: true),
        ]),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildToggleRow(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          AppToggle(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _buildTextButtonRow(
    String title,
    VoidCallback onPressed, {
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              isDestructive ? Icons.exit_to_app : Icons.logout,
              color: isDestructive ? Colors.red : Colors.black87,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isDestructive ? Colors.red : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
