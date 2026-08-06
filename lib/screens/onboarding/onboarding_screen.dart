import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../auth/auth_screen.dart';
import 'onboarding_page_data.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  bool get _isLastPage => _currentPage == onboardingPages.length - 1;

  void _finishOnboarding() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const AuthScreen()));
  }

  void _goToNextPage() {
    if (_isLastPage) {
      _finishOnboarding();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(showSkip: !_isLastPage, onSkip: _finishOnboarding),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingPages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  return _OnboardingPage(data: onboardingPages[index]);
                },
              ),
            ),
            _BottomBar(
              pageCount: onboardingPages.length,
              currentPage: _currentPage,
              isLastPage: _isLastPage,
              onNext: _goToNextPage,
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.showSkip, required this.onSkip});

  final bool showSkip;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Text(
            'UniVerse',
            style: TextStyle(
              fontFamily: kLogoFontFamily,
              fontSize: 22,
              color: AppColors.primary,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: AnimatedOpacity(
              opacity: showSkip ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: TextButton(
                onPressed: showSkip ? onSkip : null,
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: AppColors.slate,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.data});

  final OnboardingPageData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 12, 28, 0),
          child: Column(
            children: [
              Text(
                data.headline,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: kHeadlineFontFamily,
                  fontSize: 50,
                  height: 1.05,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                data.subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color: AppColors.slate,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Full-bleed: no horizontal inset, and the bottom fades into the
        // page background instead of sitting in a boxed card.
        Expanded(
          child: SizedBox(
            width: double.infinity,
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.white, Colors.transparent],
                stops: [0.0, 0.75, 1.0],
              ).createShader(bounds),
              blendMode: BlendMode.dstIn,
              child: Image.asset(
                data.imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.pageCount,
    required this.currentPage,
    required this.isLastPage,
    required this.onNext,
  });

  final int pageCount;
  final int currentPage;
  final bool isLastPage;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 18, 28, 20),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final progress = (currentPage + 1) / pageCount;
                return Stack(
                  children: [
                    Container(
                      height: 7,
                      color: AppColors.primary.withValues(alpha: 0.15),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      height: 7,
                      width: constraints.maxWidth * progress,
                      color: AppColors.primary,
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: Text(
                isLastPage ? 'Get Started' : 'Next',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
