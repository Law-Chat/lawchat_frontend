import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../theme/colors.dart';

class HistoryItem extends StatelessWidget {
  const HistoryItem({
    super.key,
    required this.chatId,
    required this.title,
    required this.onTap,
    required this.onDelete,
  });

  final int chatId;
  final String title;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Slidable(
        key: ValueKey(chatId),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.26,
          children: [
            CustomSlidableAction(
              onPressed: (_) {},
              autoClose: false,
              backgroundColor: Colors.transparent,
              child: const SizedBox.expand(),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              flex: 1,
            ),
            SlidableAction(
              onPressed: (_) => onDelete(),
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              icon: Icons.delete_outline_rounded,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              flex: 5,
            ),
          ],
        ),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black.withOpacity(0.05)),
            ),
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, color: AppColors.quaternary),
            ),
          ),
        ),
      ),
    );
  }
}
