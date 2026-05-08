import 'package:flutter/material.dart';

class AuthSurfaceCard extends StatelessWidget {
  const AuthSurfaceCard({
    required this.title,
    required this.subtitle,
    required this.children,
    super.key,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
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
            title,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }
}
