import 'package:flutter/material.dart';
import '../../ui/components/button.dart';
import '../../ui/components/input.dart';
import '../../ui/components/modal.dart';
import '../../ui/components/checkbox.dart';
import '../../ui/components/toggle.dart';
import '../../theme/colors.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Inputs
  final _disabledCtrl = TextEditingController(text: '홍길동 · hong@example.com');
  final _chatCtrl = TextEditingController();
  final _searchCtrl = TextEditingController();

  // Checkbox / Toggle states
  bool _checkedA = false;
  bool _checkedB = true;
  bool _toggleA = false;
  bool _toggleB = true;

  @override
  void dispose() {
    _disabledCtrl.dispose();
    _chatCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            _Section(
              title: 'Buttons',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('squareIcon', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      AppButton(
                        variant: AppButtonVariant.squareIcon,
                        icon: LucideIcons.settings,
                        onPressed: () {},
                      ),
                      AppButton(
                        variant: AppButtonVariant.squareIcon,
                        icon: LucideIcons.heart,
                        onPressed: () {},
                      ),
                      AppButton(
                        variant: AppButtonVariant.squareIcon,
                        icon: LucideIcons.share2,
                        onPressed: () {},
                      ),
                      AppButton(
                        variant: AppButtonVariant.squareIcon,
                        icon: LucideIcons.camera,
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('primary', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  AppButton(
                    variant: AppButtonVariant.primary,
                    label: '확인',
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _Section(
              title: 'Inputs',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('disabledWithIcon', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  AppInput(
                    variant: AppInputVariant.disabledWithIcon,
                    controller: _disabledCtrl,
                    hintText: '계정 정보',
                    leading: LucideIcons.user,
                  ),
                  const SizedBox(height: 16),

                  const Text('chat (with trailing action)', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  AppInput(
                    variant: AppInputVariant.chat,
                    controller: _chatCtrl,
                    hintText: '무엇이든 물어보세요',
                    trailingIcon: LucideIcons.send,
                    onTrailingPressed: () {
                      if (_chatCtrl.text.trim().isEmpty) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('전송: ${_chatCtrl.text}')),
                      );
                      _chatCtrl.clear();
                      setState(() {});
                    },
                    compact: true,
                  ),
                  const SizedBox(height: 16),

                  const Text('search (suffix icon only)', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  AppInput(
                    variant: AppInputVariant.search,
                    controller: _searchCtrl,
                    hintText: '검색어를 입력하세요',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _Section(
              title: 'Modal',
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      variant: AppButtonVariant.primary,
                      label: '모달 열기',
                      onPressed: () {
                        AppModal.show(
                          context: context,
                          title: '모달 제목',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('여기에 원하는 위젯을 배치하세요.'),
                              SizedBox(height: 12),
                              Text('배경은 background, 구분선은 disable 컬러입니다.'),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _Section(
              title: 'Checkbox',
              child: Row(
                children: [
                  AppCheckbox(
                    value: _checkedA,
                    onChanged: (v) => setState(() => _checkedA = v),
                  ),
                  const SizedBox(width: 12),
                  const Text('unchecked'),
                  const SizedBox(width: 24),
                  AppCheckbox(
                    value: _checkedB,
                    onChanged: (v) => setState(() => _checkedB = v),
                  ),
                  const SizedBox(width: 12),
                  const Text('checked'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _Section(
              title: 'Toggle',
              child: Row(
                children: [
                  AppToggle(
                    value: _toggleA,
                    onChanged: (v) => setState(() => _toggleA = v),
                  ),
                  const SizedBox(width: 16),
                  const Text('off'),
                  const SizedBox(width: 32),
                  AppToggle(
                    value: _toggleB,
                    onChanged: (v) => setState(() => _toggleB = v),
                  ),
                  const SizedBox(width: 16),
                  const Text('on'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.secondary,
              )),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
