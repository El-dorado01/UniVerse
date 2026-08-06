import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF295EAD);
  static const Color primaryDark = Color(0xFF16407E);
  static const Color background = Colors.white;
  static const Color slate = Color(0xFF5C6B84);
}

/// Font used for the "UniVerse" logo wordmark.
const String kLogoFontFamily = 'Mogra';

/// Bold display font used for punchy onboarding-style headlines.
const String kHeadlineFontFamily = 'LilitaOne';

/// Body font used everywhere else (buttons, labels, paragraphs).
const String kBodyFontFamily = 'Fredoka';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.primary,
      surface: AppColors.background,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: kBodyFontFamily,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
