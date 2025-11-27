import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/colors.dart';
import '../../ui/components/button.dart';
import '../../models/chat_models.dart';

class LawDetailPage extends StatelessWidget {
  const LawDetailPage({super.key, required this.relatedLaw});

  final RelatedLaw relatedLaw;

  @override
  Widget build(BuildContext context) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              relatedLaw.name,
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
              relatedLaw.content,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: AppColors.secondary,
              ),
            ),

            const SizedBox(height: 20),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (relatedLaw.keywords ?? [])
                  .map((k) => _Tag('#$k'))
                  .toList(),
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

class _Tag extends StatelessWidget {
  final String text;
  const _Tag(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
