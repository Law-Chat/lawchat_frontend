import 'package:flutter/material.dart';
import '../../theme/colors.dart';

enum AppInputVariant { disabledWithIcon, chat, search }

class AppInput extends StatelessWidget {
  const AppInput({
    super.key,
    required this.variant,
    this.controller,
    this.hintText,
    this.leading,
    this.trailingIcon,
    this.onTrailingPressed,
    this.height,
    this.compact = false,
  });

  final AppInputVariant variant;
  final TextEditingController? controller;
  final String? hintText;
  final IconData? leading;
  final IconData? trailingIcon;
  final VoidCallback? onTrailingPressed;
  final double? height;
  final bool compact;

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: color, width: 1),
  );

  @override
  Widget build(BuildContext context) {
    final bool slim = variant == AppInputVariant.chat && compact;
    final double h = height ?? (slim ? 40 : 48);
    final double fontSize = 14;
    final double textLine = slim ? 20 : 22;
    final double vPad = ((h - textLine) / 2).clamp(4, 12).toDouble();
    final double iconSize = slim ? 18 : 22;

    InputDecoration decoration({
      required Color fill,
      required Color borderColor,
      Color? hintColor,
      Widget? prefixIcon,
      Widget? suffixIcon,
    }) =>
        InputDecoration(
          isDense: slim,
          filled: true,
          fillColor: fill,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: vPad),
          hintText: hintText,
          hintStyle: TextStyle(color: hintColor ?? AppColors.disable, fontSize: fontSize),
          prefixIcon: prefixIcon,
          prefixIconConstraints: BoxConstraints(minWidth: slim ? 36 : 40, minHeight: slim ? 36 : 40),
          suffixIcon: suffixIcon,
          suffixIconConstraints: BoxConstraints(minWidth: slim ? 36 : 40, minHeight: slim ? 36 : 40),
          enabledBorder: _border(borderColor),
          focusedBorder: _border(borderColor),
          disabledBorder: _border(borderColor),
        );

    final textStyle = TextStyle(color: AppColors.secondary, fontSize: fontSize);

    switch (variant) {
      case AppInputVariant.disabledWithIcon:
        return SizedBox(
          height: h,
          child: TextField(
            enabled: false,
            controller: controller,
            style: textStyle,
            decoration: decoration(
              fill: AppColors.background,
              borderColor: AppColors.disable,
              prefixIcon: leading != null
                  ? Icon(leading, color: AppColors.disable, size: iconSize)
                  : null,
            ),
          ),
        );

      case AppInputVariant.chat:
        return SizedBox(
          height: h,
          child: TextField(
            controller: controller,
            style: textStyle,
            decoration: decoration(
              fill: AppColors.white,
              borderColor: AppColors.quaternary,
              hintColor: AppColors.disable,
              suffixIcon: trailingIcon != null
                  ? IconButton(
                onPressed: onTrailingPressed,
                icon: Icon(trailingIcon, color: AppColors.disable, size: iconSize),
                padding: EdgeInsets.zero,
                visualDensity: slim ? VisualDensity.compact : VisualDensity.standard,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              )
                  : null,
            ),
          ),
        );

      case AppInputVariant.search:
        return SizedBox(
          height: h,
          child: TextField(
            controller: controller,
            style: textStyle,
            decoration: decoration(
              fill: AppColors.background,
              borderColor: AppColors.quaternary,
              hintColor: AppColors.disable,
              suffixIcon: Icon(Icons.search, color: AppColors.disable, size: iconSize),
            ),
          ),
        );
    }
  }
}

