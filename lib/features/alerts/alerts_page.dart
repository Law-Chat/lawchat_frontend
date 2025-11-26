import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lawchat_frontend/services/auth_service.dart';
import 'package:lawchat_frontend/theme/colors.dart';
import 'package:url_launcher/url_launcher.dart';

// 1. Updated data model to match API spec and added fromJson factory
class NotificationItem {
  final int notificationId;
  final String? message;
  final String? link;
  final bool isRead;
  final String? createdAt;

  NotificationItem({
    required this.notificationId,
    this.message,
    this.link,
    required this.isRead,
    this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      notificationId: json['notificationId'],
      message: json['message'],
      link: json['link'],
      isRead: json['isRead'],
      createdAt: json['createdAt'],
    );
  }

  NotificationItem copyWith({bool? isRead}) {
    return NotificationItem(
      notificationId: notificationId,
      message: message,
      link: link,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }
}

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  _AlertsPageState createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  List<NotificationItem> _notifications = [];
  bool _isLoading = true;
  String? _errorMessage;

  late Map<int, String> _notificationTypes;
  final _random = Random();
  final _types = const ['법령 업데이트', '채팅 답변', '마케팅'];

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  // 2. Added function to fetch notifications from the API
  Future<void> _fetchNotifications() async {
    try {
      final token = await AuthService.instance.getToken();
      if (token == null) throw Exception('Authentication token not found.');

      final dio = Dio(
        BaseOptions(
          baseUrl: dotenv.env['BASE_URL'] ?? '',
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final response = await dio.get('/api/notifications');
      final List<dynamic> data = response.data['notifications'];
      final notifications = data
          .map((item) => NotificationItem.fromJson(item))
          .toList();

      setState(() {
        _notifications = notifications;
        _notificationTypes = {
          // Assign random types for icons
          for (var n in notifications)
            n.notificationId: _types[_random.nextInt(_types.length)],
        };
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = '알림을 불러오지 못했습니다.';
        _isLoading = false;
      });
    }
  }

  String _formatCreatedAt(String? dateString) {
    if (dateString == null) return '';
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('yyyy.MM.dd HH:mm').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case '법령 업데이트':
        return Icons.article_outlined;
      case '채팅 답변':
        return Icons.chat_bubble_outline;
      case '마케팅':
        return Icons.campaign_outlined;
      default:
        return Icons.notifications_none;
    }
  }

  // 3. Implemented onTap handler
  Future<void> _onNotificationTap(
    NotificationItem notification,
    int index,
  ) async {
    // Mark as read locally
    if (!notification.isRead) {
      setState(() {
        _notifications[index] = notification.copyWith(isRead: true);
      });
      // TODO: Add API call to mark as read on the server
    }

    // Launch URL
    final link = notification.link;
    if (link != null && await canLaunchUrl(Uri.parse(link))) {
      await launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication);
    } else {
      // Optional: show a snackbar if the link is invalid
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          '알림',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }
    if (_notifications.isEmpty) {
      return const Center(child: Text('표시할 알림이 없습니다.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        final type =
            _notificationTypes[notification.notificationId] ?? _types[0];

        return Container(
          color: notification.isRead ? AppColors.white : AppColors.background,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: notification.isRead
                  ? AppColors.tertiary
                  : AppColors.primary,
              child: Icon(
                _getIconForType(type),
                color: notification.isRead
                    ? AppColors.quaternary
                    : AppColors.white,
              ),
            ),
            title: Text(
              notification.message ?? '',
              style: TextStyle(
                fontSize: 14,
                fontWeight: notification.isRead
                    ? FontWeight.normal
                    : FontWeight.bold,
              ),
            ),
            subtitle: Text(
              _formatCreatedAt(notification.createdAt),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            onTap: () => _onNotificationTap(notification, index),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox.shrink(),
    );
  }
}
