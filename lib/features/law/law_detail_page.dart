import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/colors.dart';
import '../../ui/components/button.dart';

class LawDetailPage extends StatelessWidget {
  const LawDetailPage({super.key, required this.relatedLaw});

  final String relatedLaw;

  @override
  Widget build(BuildContext context) {
    final String raw = relatedLaw;
    String titleText;
    String bodyText;

    final int slashIndex = raw.indexOf('/');

    if (slashIndex == -1) {
      titleText = raw.isNotEmpty ? raw.trim() : '법령 상세';
      bodyText = '';
    } else {
      titleText = raw.substring(0, slashIndex).trim();
      bodyText = raw.substring(slashIndex + 1).trim();
      if (titleText.isEmpty) titleText = '법령 상세';
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        centerTitle: true,
        leading: const SizedBox(),
        title: const Text(
          '법령 상세',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 16,
            color: AppColors.secondary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              titleText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 20),

            const Divider(color: AppColors.tertiary, height: 1),
            const SizedBox(height: 20),

            Text(
              bodyText.isEmpty ? '관련 법령 본문 정보가 없습니다.' : bodyText,
              style: const TextStyle(
                height: 1.5,
                color: AppColors.secondary,
                fontSize: 14,
              ),
            ),

            const Spacer(),

            AppButton(
              variant: AppButtonVariant.primary,
              label: '대화로 돌아가기',
              onPressed: () => context.pop(),
              height: 48,
            ),
          ],
        ),
      ),
    );
  }
}
