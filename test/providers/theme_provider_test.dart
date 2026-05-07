import 'package:cs_app/providers/binary_practice_provider.dart';
import 'package:cs_app/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('theme defaults to dark when preference is not set', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(container.dispose);

    expect(container.read(themeProvider), ThemeMode.dark);
  });

  test('theme initializes from stored preference', () async {
    SharedPreferences.setMockInitialValues({'isDarkMode': false});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(container.dispose);

    expect(container.read(themeProvider), ThemeMode.light);
  });

  test('toggleTheme switches mode and persists preference', () async {
    SharedPreferences.setMockInitialValues({'isDarkMode': true});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(container.dispose);
    final notifier = container.read(themeProvider.notifier);

    notifier.toggleTheme();
    expect(container.read(themeProvider), ThemeMode.light);
    expect(prefs.getBool('isDarkMode'), isFalse);

    notifier.toggleTheme();
    expect(container.read(themeProvider), ThemeMode.dark);
    expect(prefs.getBool('isDarkMode'), isTrue);
  });
}
