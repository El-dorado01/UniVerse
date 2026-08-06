class OnboardingPageData {
  const OnboardingPageData({
    required this.imagePath,
    required this.headline,
    required this.subtitle,
  });

  final String imagePath;
  final String headline;
  final String subtitle;
}

const onboardingPages = [
  OnboardingPageData(
    imagePath: 'assets/onboarding/onboarding_1.jpg',
    headline: 'YOUR CAMPUS. YOUR UNIVERSE.',
    subtitle: 'Everything happening at BUK — in one place, made for students.',
  ),
  OnboardingPageData(
    imagePath: 'assets/onboarding/onboarding_2.jpg',
    headline: 'FIND YOUR PEOPLE.',
    subtitle:
        'Join communities, connect with your department, and find study '
        'partners who get it.',
  ),
  OnboardingPageData(
    imagePath: 'assets/onboarding/onboarding_3.jpg',
    headline: 'NEVER MISS WHAT MATTERS.',
    subtitle: 'Events, opportunities, and campus news — personalized for you.',
  ),
];
