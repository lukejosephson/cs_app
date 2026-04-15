import 'package:flutter/material.dart';

class SignInActionButton extends StatelessWidget {
  const SignInActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.isLoading,
    super.key,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(icon),
        label: Text(label),
      ),
    );
  }
}
