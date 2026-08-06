/// UniVerse - Campus Connect + Social App for BUK Students
///
/// This application is a social lifestyle platform designed to connect
/// students of Bayero University Kano. It focuses on social engagement,
/// campus life, and student connectivity.
library;

import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const UniVerseApp());
}

class UniVerseApp extends StatelessWidget {
  const UniVerseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniVerse',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const SplashScreen(),
    );
  }
}
