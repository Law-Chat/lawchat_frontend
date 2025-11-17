import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lawchat_frontend/ui/components/button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'image': 'assets/images/onboarding_1.png',
      'title': '금융 법률, AI로 가장\n빠르게 이해하는 방법',
      'subtitle': '복잡한 조문 속에서도\n핵심만 명확히 전달합니다.',
    },
    {
      'image': 'assets/images/onboarding_2.png',
      'title': '법의 언어를\n데이터로 읽는 챗봇',
      'subtitle': '어려운 금융 규정도\n자연어로 쉽게 찾아드립니다.',
    },
    {
      'image': 'assets/images/onboarding_3.png',
      'title': '필요한 금융 정보,\n가장 정확한 한 줄로',
      'subtitle': '신뢰할 수 있는 법령 요약과 근거를\n한눈에 제공합니다.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.go('/login'),
                child: const Text('Skip'),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingData.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingPageContent(data: _onboardingData[index]);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _onboardingData.length,
                (index) => buildDot(index, context),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _currentPage == _onboardingData.length - 1
                  ? AppButton(
                      variant: AppButtonVariant.primary,
                      label: '시작하기',
                      onPressed: () => context.go('/login'),
                    )
                  : const SizedBox(height: 48),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: 10,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: _currentPage == index
            ? Theme.of(context).primaryColor
            : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}

class OnboardingPageContent extends StatelessWidget {
  final Map<String, String> data;

  const OnboardingPageContent({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(data['image']!, height: 300),
        const SizedBox(height: 40),
        Text(
          data['title']!,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          data['subtitle']!,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
