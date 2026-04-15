import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import 'create_account_screen.dart';
import '../widgets/auth/sign_in_action_button.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  String? _accountCreatedMessage;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final authActionState = ref.watch(authActionStateProvider);
    final isLoading = authActionState.isLoading;
    final authController = ref.read(authControllerProvider);
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final canSubmitEmailForm = email.isNotEmpty && password.isNotEmpty;

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
                      'Use email/password or Google to sign in.',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                    if (_accountCreatedMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _accountCreatedMessage!,
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.greenAccent.shade200,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      enabled: !isLoading,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'name@example.com',
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      autofillHints: const [AutofillHints.password],
                      enabled: !isLoading,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    SignInActionButton(
                      label: 'Sign in with Email',
                      icon: Icons.email_outlined,
                      isLoading: isLoading,
                      onPressed: canSubmitEmailForm
                          ? () => authController.signInWithEmailAndPassword(
                                email: email,
                                password: password,
                              )
                          : null,
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: isLoading
                          ? null
                          : () => _openCreateAccount(context),
                      icon: const Icon(Icons.person_add_alt_1_rounded),
                      label: const Text('Create Account'),
                    ),
                    const SizedBox(height: 12),
                    SignInActionButton(
                      label: 'Continue with Google',
                      icon: Icons.login_rounded,
                      isLoading: isLoading,
                      onPressed: () => authController.signInWithGoogle(),
                    ),
                    if (authActionState.hasError) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Authentication failed: ${authActionState.error}',
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

  Future<void> _openCreateAccount(BuildContext context) async {
    final message = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) => const CreateAccountScreen(),
      ),
    );

    if (message != null && mounted) {
      setState(() {
        _accountCreatedMessage = message;
      });
    }
  }
}
