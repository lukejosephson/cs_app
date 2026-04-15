import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: CsPracticeApp()));
}

class CsPracticeApp extends StatelessWidget {
  const CsPracticeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF4F8CFF),
      brightness: Brightness.dark,
    );

    return MaterialApp(
      title: 'CS Practice',
      theme: ThemeData(
        colorScheme: colorScheme,
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0B1020),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
        ),
        cardTheme: const CardThemeData(
          margin: EdgeInsets.zero,
          color: Color(0xFF141B2D),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
