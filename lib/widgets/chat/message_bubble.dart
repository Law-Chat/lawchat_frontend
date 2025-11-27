import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../models/chat_models.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage msg;
  final VoidCallback? onExplore;

  const MessageBubble({super.key, required this.msg, this.onExplore});

  @override
  Widget build(BuildContext context) {
    final isUser = msg.role == ChatRole.user;

    if (isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.fromLTRB(48, 8, 0, 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            msg.text,
            style: const TextStyle(color: Colors.white, height: 1.4),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/icon.png', width: 45, height: 45),

                if (onExplore != null)
                  GestureDetector(
                    onTap: onExplore,
                    child: const Text(
                      '출처보기',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              msg.text,
              style: const TextStyle(
                color: AppColors.secondary,
                height: 1.6,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await Clipboard.setData(ClipboardData(text: msg.text));

                      final messenger = ScaffoldMessenger.maybeOf(context);
                      if (messenger == null) return;

                      messenger.showSnackBar(
                        const SnackBar(
                          content: Text('답변이 복사되었습니다.'),
                          duration: Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: const Icon(
                      LucideIcons.copy,
                      size: 14,
                      color: AppColors.disable,
                    ),
                  ),

                  // const SizedBox(width: 8),
                  // GestureDetector(
                  //   onTap: () {},
                  //   child: const Icon(
                  //     LucideIcons.share2,
                  //     size: 14,
                  //     color: AppColors.disable,
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
