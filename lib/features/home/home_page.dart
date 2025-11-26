import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lawchat_frontend/services/auth_service.dart';
import 'package:lawchat_frontend/theme/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _name = '사용자';

  final List<String> _allQuestions = [
    '대출이나 금리 관련 규정을 정확히 알고 싶은데, 어떻게 확인하면 될까요?',
    '최근에 바뀐 금융 법령이나 새로 시행된 규정이 있다면 알려주세요.',
    '주택담보대출 시 필요한 서류와 절차에 대해 알려줘.',
    '개인정보 보호법의 주요 내용이 뭐야?',
    '전자금융거래 시 주의해야 할 점은 무엇인가요?',
    '비상장주식 거래 시 세금 문제에 대해 알려줘.',
  ];

  late List<String> _randomQuestions;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _randomQuestions = _getRandomQuestions();
  }

  Future<void> _loadUser() async {
    final user = await AuthService.instance.getUser();
    if (user['name'] != null) {
      setState(() {
        _name = user['name']!;
      });
    }
  }

  List<String> _getRandomQuestions() {
    final random = Random();
    final shuffledList = List<String>.from(_allQuestions)..shuffle(random);
    return shuffledList.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Row(
          children: [
            Image.asset('assets/images/icon.png', height: 36),
            const SizedBox(width: 8),
            const Text(
              'LawChat',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Text(
            '안녕하세요, $_name님', // Display user name
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Text('오늘의 금융법 요약을 한눈에 확인해보세요.', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 30),
          _buildSectionHeader(
            '최근 채팅',
            () => context.go('/history'),
          ), // Navigate to history
          const SizedBox(height: 10),
          SizedBox(
            height: 150, // Card height
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildRecentChatCard(
                  '대출이나 금리 관련 규정을 정확히 알고 싶은데, 어떻게 확인하면 될까요?',
                  '2025.11.03 17:19',
                ),
                _buildRecentChatCard(
                  '최근에 바뀐 금융 법령이나 새로 시행된 규정이 있다면 알려주세요.',
                  '2025.11.03 17:19',
                ),
                _buildRecentChatCard(
                  '대출이나 금리 관련 규정을 정확히 알고 싶은데, 어떻게 확인하면 될까요?',
                  '2025.11.03 17:19',
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          _buildSectionHeader('이런 질문은 어떠세요?', null),
          const SizedBox(height: 10),
          ..._randomQuestions
              .map((question) => _buildQuestionChip(question))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback? onSeeAll) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              child: const Text('전체보기 >', style: TextStyle(fontSize: 12)),
            ),
        ],
      ),
    );
  }

  Widget _buildRecentChatCard(String query, String date) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 0,
        color: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(query, maxLines: 4, overflow: TextOverflow.ellipsis),
              Text(
                date,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionChip(String question) {
    return SizedBox(
      height: 90, // Set a fixed height for the card area
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 10),
        color: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Center(
            // Center the text vertically and horizontally
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                question,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
