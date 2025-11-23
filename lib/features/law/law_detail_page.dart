import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/colors.dart';
import '../../ui/components/button.dart';

class LawDetailPage extends StatelessWidget {
  const LawDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.quaternary,
          ),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
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
            const Text(
              '금융소비자보호법 제19조 (설명의무)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 20),
            const Divider(color: AppColors.tertiary, height: 1),
            const SizedBox(height: 20),
            const Text(
              '금융상품 판매업자 등은 금융상품 계약을 체결할 때 금융소비자에게 해당 금융상품의 내용, '
              '위험요인 및 거래조건에 관하여 충실히 설명하여야 한다.',
              style: TextStyle(height: 1.5, color: AppColors.secondary),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                alignment: WrapAlignment.start,
                children: [_Tag('#대출'), _Tag('#설명의무'), _Tag('#금융상품')],
              ),
            ),
            const Spacer(),
            AppButton(
              variant: AppButtonVariant.primary,
              label: '원문 전체보기',
              onPressed: () {}, // TODO: 액션 논의 필요
              height: 48,
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.text);
  final String text;

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
