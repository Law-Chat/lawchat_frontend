import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import 'button.dart';

class AppModal {
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    Widget? child,
    String? message,
    String? confirmLabel,
    String? cancelLabel,
    VoidCallback? onConfirm,
    bool isDismissible = true,
    bool isConfirmModal = false,
    Color? confirmColor,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: isDismissible,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (ctx) {
        return Dialog(
          elevation: 10,
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.quaternary,
                        ),
                        onPressed: () => Navigator.of(ctx).pop(),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(color: AppColors.disable, height: 16),
                const SizedBox(height: 16),

                if (!isConfirmModal && child != null) child,

                if (isConfirmModal)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: AppButton(
                              variant: AppButtonVariant.outline,
                              label: cancelLabel ?? '취소',
                              onPressed: () => Navigator.of(ctx).pop(),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: AppButton(
                              variant: AppButtonVariant.primary,
                              label: confirmLabel ?? '확인',
                              bgColor: confirmColor ?? AppColors.primary,
                              iconColor: Colors.white,
                              onPressed: () {
                                Navigator.of(ctx).pop();
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  onConfirm?.call();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
