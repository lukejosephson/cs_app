import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'binary_practice_provider.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier(ref.watch(sharedPreferencesProvider));
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier(this._prefs)
    : super(
        (_prefs?.getBool(_isDarkModeKey) ?? true)
            ? ThemeMode.dark
            : ThemeMode.light,
      );

  final SharedPreferences? _prefs;
  static const _isDarkModeKey = 'isDarkMode';

  void toggleTheme() {
    final nextMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    state = nextMode;
    _prefs?.setBool(_isDarkModeKey, nextMode == ThemeMode.dark);
  }
}
