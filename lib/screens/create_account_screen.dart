import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../services/create_account_form_service.dart';
import '../widgets/auth/create_account_fields.dart';
import '../widgets/auth/sign_in_action_button.dart';

final createAccountEmailProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);
final createAccountPasswordProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);
final createAccountConfirmPasswordProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);
final createAccountValidationErrorProvider = StateProvider.autoDispose<String?>(
  (ref) => null,
);

class CreateAccountScreen extends ConsumerStatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  ConsumerState<CreateAccountScreen> createState() =>
      _CreateAccountScreenState();
}

class _CreateAccountScreenState extends ConsumerState<CreateAccountScreen> {
  static const _formService = CreateAccountFormService();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _emailController.addListener(_syncEmail);
    _passwordController.addListener(_syncPassword);
    _confirmPasswordController.addListener(_syncConfirmPassword);
  }

  @override
  void dispose() {
    _emailController.removeListener(_syncEmail);
    _passwordController.removeListener(_syncPassword);
    _confirmPasswordController.removeListener(_syncConfirmPassword);
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
    final inputValidationError = ref.watch(createAccountValidationErrorProvider);
    final isLoading = authActionState.isLoading;
    final authController = ref.read(authControllerProvider);
    final email = ref.watch(createAccountEmailProvider).trim();
    final password = ref.watch(createAccountPasswordProvider);
    final confirmedPassword = ref.watch(createAccountConfirmPasswordProvider);

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
                    CreateAccountFields(
                      emailController: _emailController,
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                      isLoading: isLoading,
                      onChanged: _onFieldChanged,
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
                    if (inputValidationError != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        inputValidationError,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.error,
                        ),
                      ),
                    ],
                    if (authActionState.hasError) ...[
                      const SizedBox(height: 12),
                      Text(
                        _formService.buildAuthErrorMessage(
                          authActionState.error!,
                        ),
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
    final validationError = _formService.validateCredentials(
      email: email,
      password: password,
      confirmedPassword: confirmedPassword,
    );
    if (validationError != null) {
      ref.read(createAccountValidationErrorProvider.notifier).state =
          validationError;
      return;
    }

    ref.read(createAccountValidationErrorProvider.notifier).state = null;

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

  void _syncEmail() {
    ref.read(createAccountEmailProvider.notifier).state = _emailController.text;
  }

  void _syncPassword() {
    ref.read(createAccountPasswordProvider.notifier).state =
        _passwordController.text;
  }

  void _syncConfirmPassword() {
    ref.read(createAccountConfirmPasswordProvider.notifier).state =
        _confirmPasswordController.text;
  }

  void _onFieldChanged(String _) {
    if (ref.read(createAccountValidationErrorProvider) != null) {
      ref.read(createAccountValidationErrorProvider.notifier).state = null;
    }
  }
}
