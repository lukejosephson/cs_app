import 'package:flutter/material.dart';

class CreateAccountFields extends StatelessWidget {
  const CreateAccountFields({
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isLoading,
    required this.onChanged,
    super.key,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isLoading;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          key: const ValueKey('create-account-email-field'),
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email],
          enabled: !isLoading,
          decoration: const InputDecoration(
            labelText: 'Email',
            hintText: 'name@example.com',
          ),
          onChanged: onChanged,
        ),
        const SizedBox(height: 12),
        TextField(
          key: const ValueKey('create-account-password-field'),
          controller: passwordController,
          obscureText: true,
          autofillHints: const [AutofillHints.newPassword],
          enabled: !isLoading,
          decoration: const InputDecoration(labelText: 'Password'),
          onChanged: onChanged,
        ),
        const SizedBox(height: 12),
        TextField(
          key: const ValueKey('create-account-confirm-password-field'),
          controller: confirmPasswordController,
          obscureText: true,
          autofillHints: const [AutofillHints.newPassword],
          enabled: !isLoading,
          decoration: const InputDecoration(labelText: 'Verify Password'),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
