import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lawchat_frontend/theme/colors.dart';
import 'package:lawchat_frontend/ui/components/toggle.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _pushNotifications = true;
  bool _legalNotifications = true;
  bool _adEmails = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          '프로필',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 50,
            // backgroundImage: AssetImage('assets/images/profile_placeholder.png'),
            child: Icon(Icons.person, size: 50),
          ),
          const SizedBox(height: 16),
          const Text(
            'Gildong Hong', // Replace with actual user name
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'example@gmail.com', // Replace with actual user email
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 40),
          _buildSectionHeader('알림 설정'),
          _buildSettingsCard([
            _buildToggleRow(
              '푸시 알림 수신 여부',
              _pushNotifications,
              (value) => setState(() => _pushNotifications = value),
            ),
            _buildToggleRow(
              '계정 법령 알림 여부',
              _legalNotifications,
              (value) => setState(() => _legalNotifications = value),
            ),
            _buildToggleRow(
              '광고성 이메일 수신 여부',
              _adEmails,
              (value) => setState(() => _adEmails = value),
            ),
          ]),
          const SizedBox(height: 30),
          _buildSectionHeader('계정 설정'),
          _buildSettingsCard([
            _buildTextButtonRow('로그아웃', () => context.go('/login')),
            _buildTextButtonRow(
              '서비스 탈퇴',
              () => context.go('/login'),
              isDestructive: true,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
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
