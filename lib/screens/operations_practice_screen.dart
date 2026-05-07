import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/operations_practice_provider.dart';
import '../widgets/code_display_box.dart';
import '../widgets/operations_input_panel.dart';

class OperationsPracticeScreen extends ConsumerWidget {
  const OperationsPracticeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puzzlesAsync = ref.watch(operationsPracticeProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Operations Practice')),
      body: puzzlesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              color: colorScheme.errorContainer.withValues(alpha: 0.65),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: colorScheme.onErrorContainer,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'We could not load operations challenges.',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onErrorContainer,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Please try again in a moment.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onErrorContainer.withValues(
                          alpha: 0.9,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        data: (puzzles) {
          if (puzzles.isEmpty) {
            return Center(
              child: Text(
                'No operations challenges available right now.',
                style: textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            );
          }

          final validPuzzles = puzzles
              .where((puzzle) => puzzle.hasRequiredPromptFields)
              .toList(growable: false);
          if (validPuzzles.isEmpty) {
            return Center(
              child: Text(
                'No valid operations challenges available right now.',
                style: textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            );
          }

          final currentPuzzle = validPuzzles.first;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Operations practice',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Difficulty: ${currentPuzzle.difficulty}',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.75),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tags: ${currentPuzzle.tags.isEmpty ? 'None' : currentPuzzle.tags.join(', ')}',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.75),
                ),
              ),
              const SizedBox(height: 12),
              CodeDisplayBox(snippet: currentPuzzle.snippet),
              const SizedBox(height: 12),
              OperationsInputPanel(
                key: ValueKey('operations-input-panel-${currentPuzzle.id}'),
                puzzleId: currentPuzzle.id,
                targetPrompt: currentPuzzle.target,
                correctAnswer: currentPuzzle.answer,
              ),
            ],
          );
        },
      ),
    );
  }
}
