import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/loop_tracing_provider.dart';

class LoopInputPanel extends ConsumerWidget {
  const LoopInputPanel({
    required this.targetVariable,
    required this.correctAnswer,
    super.key,
  });

  final String targetVariable;
  final String correctAnswer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(loopScoutControllerProvider.notifier);
    final state = ref.watch(loopScoutControllerProvider);
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Target variable: $targetVariable',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const ValueKey('loop-answer-input'),
              onChanged: controller.updateInput,
              decoration: const InputDecoration(
                labelText: 'Your answer',
                hintText: 'Enter final value',
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              key: const ValueKey('loop-check-answer-button'),
              onPressed: () => controller.submitAnswer(correctAnswer),
              child: const Text('Check Answer'),
            ),
            if (state.hasSubmitted) ...[
              const SizedBox(height: 12),
              Text(
                state.isCorrect
                    ? 'Success! Correct answer.'
                    : 'Not quite. Correct answer: $correctAnswer',
                style: textTheme.bodyMedium?.copyWith(
                  color: state.isCorrect
                      ? Colors.green.shade300
                      : Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
