import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/binary_practice_provider.dart';

class BinaryPracticeScreen extends ConsumerWidget {
  const BinaryPracticeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(binaryPracticeProvider);
    final controller = ref.read(binaryPracticeProvider.notifier);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    const weights = [32, 16, 8, 4, 2, 1];

    return Scaffold(
      appBar: AppBar(title: const Text('Binary Practice')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Target Number: ${state.targetNumber}',
                    style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Flip the six bits to match the target number.',
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Your Value: ${state.currentValue}',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: List.generate(weights.length, (index) {
              final isOn = state.bits[index];
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${weights[index]}',
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.75),
                    ),
                  ),
                  const SizedBox(height: 6),
                  FilledButton.tonal(
                    key: ValueKey('bit-toggle-$index'),
                    onPressed: () => controller.toggleBit(index),
                    child: Text(isOn ? '1' : '0'),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: controller.checkAnswer,
            icon: const Icon(Icons.check),
            label: const Text('Check Answer'),
          ),
          if (state.feedback != null) ...[
            const SizedBox(height: 16),
            Card(
              color: state.isCorrect == true
                  ? colorScheme.primary.withValues(alpha: 0.2)
                  : colorScheme.errorContainer.withValues(alpha: 0.85),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Text(
                  state.feedback!,
                  style: textTheme.bodyMedium?.copyWith(
                    color: state.isCorrect == true
                        ? colorScheme.onSurface
                        : colorScheme.onErrorContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
