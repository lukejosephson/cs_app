import 'package:flutter/material.dart';

import '../../models/practice_type.dart';

class PracticeOptionTile extends StatelessWidget {
  const PracticeOptionTile({
    required this.option,
    required this.onTap,
    super.key,
  });

  final PracticeType option;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.memory_rounded, color: colorScheme.primary),
        ),
        title: Text(
          option.title,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(option.description),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: colorScheme.onSurface.withValues(alpha: 0.7),
        ),
        onTap: onTap,
      ),
    );
  }
}
