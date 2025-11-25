import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/colors.dart';
import '../../models/chat_models.dart';
import '../../ui/components/input.dart';
import '../../widgets/chat/message_bubble.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ChattingPage extends StatefulWidget {
  const ChattingPage({super.key, this.thread});
  final ChatThread? thread;

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  late final List<ChatMessage> _messages;
  late String _title;
  final _input = TextEditingController();

  bool get _isOnboarding => widget.thread == null;

  @override
  void initState() {
    super.initState();
    if (_isOnboarding) {
      _title = '새 채팅';
      _messages = [];
    } else {
      _title = widget.thread!.title;
      _messages = [...widget.thread!.messages];
    }
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _send(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add(
        ChatMessage(
          role: ChatRole.user,
          text: text.trim(),
          time: DateTime.now(),
        ),
      );
      _title = _isOnboarding ? text.trim() : _title;
    });
    _input.clear();

    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        _messages.add(
          ChatMessage(
            role: ChatRole.assistant,
            text:
                '요청하신 내용에 대한 요약 답변입니다. (더미)\n\n'
                '▪️ 핵심1\n▪️ 핵심2\n\n'
                '자세한 조문은 둘러보기를 눌러 확인하세요.',
            time: DateTime.now(),
          ),
        );
      });
    });
  }

  void _openLawDetail() => context.push('/law/detail');

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.quaternary),
        onPressed: () => context.pop(),
      ),
      centerTitle: true,
      title: Text(
        _isOnboarding ? '새 채팅' : _title,
        style: const TextStyle(
          color: AppColors.secondary,
          fontWeight: FontWeight.w800,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildOnboarding() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
      children: [
        const SizedBox(height: 16),
        Center(
          child: Image.asset('assets/images/logo.png', width: 160, height: 160),
        ),
        const SizedBox(height: 20),
        _SuggestionCard(
          text: '대출이나 금리 관련 규정을 정확히 알고 싶은데,\n어떻게 확인하면 될까요?',
          onTap: () => _send('대출이나 금리 관련 규정을 정확히 알고 싶은데, 어떻게 확인하면 될까요?'),
        ),
        const SizedBox(height: 12),
        _SuggestionCard(
          text: '최근에 바뀐 금융 법령이나 새로 시행된 규정이 있다면 알려주세요.',
          onTap: () => _send('최근에 바뀐 금융 법령이나 새로 시행된 규정이 있다면 알려주세요.'),
        ),
        const SizedBox(height: 12),
        _SuggestionCard(
          text: '제가 겪고 있는 상황에 적용될 수 있는 금융 법률이 있을까요?',
          onTap: () => _send('제가 겪고 있는 상황에 적용될 수 있는 금융 법률이 있을까요?'),
        ),
      ],
    );
  }

  Widget _buildChat() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      itemCount: _messages.length,
      itemBuilder: (_, i) {
        final m = _messages[i];
        return MessageBubble(
          msg: m,
          onExplore: m.role == ChatRole.assistant ? _openLawDetail : null,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _isOnboarding ? _buildOnboarding() : _buildChat(),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isOnboarding) // TODO: if (!_isOnboarding && _canRegenerate) 재생성 조건 수정
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {}, // TODO: 재생성 로직 Api
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(12),

                              border: Border.all(
                                color: AppColors.tertiary,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  LucideIcons.refreshCw,
                                  size: 16,
                                  color: AppColors.quaternary,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Regenerate Response',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    color: AppColors.quaternary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  AppInput(
                    variant: AppInputVariant.chat,
                    controller: _input,
                    hintText: '무엇이든 물어보세요',
                    trailingIcon: LucideIcons.send,
                    onTrailingPressed: () => _send(_input.text),
                    compact: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({required this.text, required this.onTap});
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.quaternary),
          ),
        ),
      ),
    );
  }
}
