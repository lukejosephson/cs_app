import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../widgets/auth/sign_in_action_button.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final authActionState = ref.watch(authActionStateProvider);
    final isLoading = authActionState.isLoading;
    final authController = ref.read(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1C2742), Color(0xFF111A30)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: const Color(0xFF25314A)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sign in to CS Practice',
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Use Google or continue anonymously to start practicing.',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SignInActionButton(
                      label: 'Continue with Google',
                      icon: Icons.login_rounded,
                      isLoading: isLoading,
                      onPressed: () => authController.signInWithGoogle(),
                    ),
                    const SizedBox(height: 12),
                    SignInActionButton(
                      label: 'Continue Anonymously',
                      icon: Icons.person_outline_rounded,
                      isLoading: isLoading,
                      onPressed: () => authController.signInAnonymously(),
                    ),
                    if (authActionState.hasError) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Sign-in failed: ${authActionState.error}',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.error,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
