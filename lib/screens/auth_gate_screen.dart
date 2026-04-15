import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import 'home_screen.dart';
import 'sign_in_screen.dart';

class AuthGateScreen extends ConsumerWidget {
  const AuthGateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (isSignedIn) {
        if (isSignedIn) {
          return const HomeScreen();
        }
        return const SignInScreen();
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Authentication unavailable: $error',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
