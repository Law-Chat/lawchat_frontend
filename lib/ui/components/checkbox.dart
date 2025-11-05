import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = 20,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: value ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(6),
          border: value
              ? null
              : Border.all(color: AppColors.disable, width: 1.2),
        ),
        child: value
            ? const Icon(Icons.check, size: 16, color: AppColors.white)
            : null,
      ),
    );
  }
}
