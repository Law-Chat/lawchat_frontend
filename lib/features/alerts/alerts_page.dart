import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lawchat_frontend/theme/colors.dart';

class NotificationItem {
  final int notificationId;
  final String? message;
  final bool isRead;
  final String? createdAt;

  NotificationItem({
    required this.notificationId,
    this.message,
    required this.isRead,
    this.createdAt,
  });

  // copyWith method to easily update properties
  NotificationItem copyWith({
    int? notificationId,
    String? message,
    bool? isRead,
    String? createdAt,
  }) {
    return NotificationItem(
      notificationId: notificationId ?? this.notificationId,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  _AlertsPageState createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  late List<NotificationItem> _notifications;
  late Map<int, String> _notificationTypes;
  final _random = Random();
  final _types = const ['법령 업데이트', '채팅 답변', '마케팅'];

  @override
  void initState() {
    super.initState();
    _notifications = _generateDummyNotifications();
    _notificationTypes = {
      for (var notif in _notifications)
        notif.notificationId: _types[_random.nextInt(_types.length)],
    };
  }

  List<NotificationItem> _generateDummyNotifications() {
    return [
      NotificationItem(
        notificationId: 1,
        message: '현진님, 최근 확인한 주제(대출, 금리)에 관련된 새로운 규제가 추가되었습니다.',
        isRead: false,
        createdAt: '2024-11-24T10:30:00',
      ),
      NotificationItem(
        notificationId: 2,
        message: '대출 관련 질문에 대한 답변이 도착했습니다.',
        isRead: true,
        createdAt: '2024-11-23T18:05:00',
      ),
      NotificationItem(
        notificationId: 3,
        message: '전자금융거래법이 일부 개정되었습니다.',
        isRead: true,
        createdAt: '2024-11-20T09:00:00',
      ),
      NotificationItem(
        notificationId: 4,
        message: '(광고) 새로운 맞춤형 법률 요약 서비스를 만나보세요!',
        isRead: true,
        createdAt: '2024-11-18T11:00:00',
      ),
    ];
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
      body: _notifications.isEmpty
          ? const Center(child: Text('표시할 알림이 없습니다.'))
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                final type =
                    _notificationTypes[notification.notificationId] ??
                    _types[0];

                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  color: notification.isRead
                      ? AppColors.white
                      : AppColors.background,
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
                    onTap: () {
                      if (!notification.isRead) {
                        setState(() {
                          _notifications[index] = notification.copyWith(
                            isRead: true,
                          );
                        });
                      }
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox.shrink(),
            ),
    );
  }
}
