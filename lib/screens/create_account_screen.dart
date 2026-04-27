import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../widgets/auth/sign_in_action_button.dart';

class CreateAccountScreen extends ConsumerStatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  ConsumerState<CreateAccountScreen> createState() =>
      _CreateAccountScreenState();
}

class _CreateAccountScreenState extends ConsumerState<CreateAccountScreen> {
  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  static final RegExp _passwordLetterPattern = RegExp(r'[A-Za-z]');
  static final RegExp _passwordDigitPattern = RegExp(r'\d');

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  String? _inputValidationError;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
    final confirmedPassword = _confirmPasswordController.text;

    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
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
                      'Create your account',
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Set up an email and password to save your progress.',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      key: const ValueKey('create-account-email-field'),
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
                      key: const ValueKey('create-account-password-field'),
                      controller: _passwordController,
                      obscureText: true,
                      autofillHints: const [AutofillHints.newPassword],
                      enabled: !isLoading,
                      decoration: const InputDecoration(labelText: 'Password'),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      key: const ValueKey(
                        'create-account-confirm-password-field',
                      ),
                      controller: _confirmPasswordController,
                      obscureText: true,
                      autofillHints: const [AutofillHints.newPassword],
                      enabled: !isLoading,
                      decoration: const InputDecoration(
                        labelText: 'Verify Password',
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    SignInActionButton(
                      key: const ValueKey('create-account-submit-button'),
                      label: 'Create Account',
                      icon: Icons.person_add_alt_1_rounded,
                      isLoading: isLoading,
                      onPressed: () => _submitCreateAccount(
                        authController: authController,
                        email: email,
                        password: password,
                        confirmedPassword: confirmedPassword,
                      ),
                    ),
                    if (_inputValidationError != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _inputValidationError!,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.error,
                        ),
                      ),
                    ],
                    if (authActionState.hasError) ...[
                      const SizedBox(height: 12),
                      Text(
                        _buildAuthErrorMessage(authActionState.error!),
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

  Future<void> _submitCreateAccount({
    required AuthController authController,
    required String email,
    required String password,
    required String confirmedPassword,
  }) async {
    final validationError = _validateCredentials(
      email: email,
      password: password,
      confirmedPassword: confirmedPassword,
    );
    if (validationError != null) {
      setState(() {
        _inputValidationError = validationError;
      });
      return;
    }

    setState(() {
      _inputValidationError = null;
    });

    final isCreated = await authController.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (!isCreated) {
      return;
    }

    await authController.signOut();

    if (!mounted) return;
    Navigator.of(context).pop('Account created successfully. Please sign in.');
  }

  String? _validateCredentials({
    required String email,
    required String password,
    required String confirmedPassword,
  }) {
    if (email.isEmpty) {
      return 'Please enter an email address.';
    }
    if (!_emailPattern.hasMatch(email)) {
      return 'Please enter a valid email address.';
    }
    if (password.isEmpty) {
      return 'Please enter a password.';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters long.';
    }
    if (!_passwordLetterPattern.hasMatch(password) ||
        !_passwordDigitPattern.hasMatch(password)) {
      return 'Password must include at least one letter and one number.';
    }
    if (confirmedPassword.isEmpty) {
      return 'Please verify your password.';
    }
    if (password != confirmedPassword) {
      return 'Password verification does not match.';
    }
    return null;
  }

  String _buildAuthErrorMessage(Object error) {
    if (error is TimeoutException) {
      return 'Authentication timed out. Check your internet connection and try again.';
    }
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'operation-not-allowed':
          return 'Email/password sign-in is not enabled in Firebase Console.';
        case 'email-already-in-use':
          return 'That email is already in use. Try signing in instead.';
        case 'invalid-email':
          return 'Firebase rejected this email address as invalid.';
        case 'weak-password':
          return 'Firebase rejected this password as too weak.';
        case 'network-request-failed':
          return 'Network request failed while contacting Firebase.';
        default:
          return 'Authentication failed (${error.code}): ${error.message ?? 'Unknown error'}';
      }
    }

    return 'Authentication failed: $error';
  }
}
