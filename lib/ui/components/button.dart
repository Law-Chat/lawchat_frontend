import 'package:flutter/material.dart';
import '../../theme/colors.dart';

enum AppButtonVariant { squareIcon, primary, outline }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.variant,
    this.icon,
    this.label,
    this.onPressed,
    this.width,
    this.height,
    this.bgColor,
    this.iconColor,
  });

  final AppButtonVariant variant;
  final IconData? icon;
  final String? label;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final Color? bgColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case AppButtonVariant.squareIcon:
        return SizedBox(
          width: width ?? 48,
          height: height ?? 48,
          child: Material(
            color: bgColor ?? AppColors.white,
            elevation: 3,
            shadowColor: Colors.black.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onPressed,
              child: Center(
                child: Icon(
                  icon,
                  color: iconColor ?? AppColors.secondary,
                  size: 22,
                ),
              ),
            ),
          ),
        );

      case AppButtonVariant.primary:
        return SizedBox(
          width: width ?? double.infinity,
          height: height ?? 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: bgColor ?? AppColors.primary,
              foregroundColor: iconColor ?? AppColors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            onPressed: onPressed,
            child: Text(label ?? 'Button'),
          ),
        );

      case AppButtonVariant.outline:
        return SizedBox(
          width: width ?? double.infinity,
          height: height ?? 48,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: bgColor ?? AppColors.background,
              foregroundColor: iconColor ?? AppColors.secondary,
              side: BorderSide(color: AppColors.disable, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            onPressed: onPressed,
            child: Text(label ?? 'Button'),
          ),
        );
    }
  }
}
