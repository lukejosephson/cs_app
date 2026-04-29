import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/loop_provider.dart';
import '../providers/loop_tracing_provider.dart';
import '../widgets/code_display_box.dart';
import '../widgets/loop_input_panel.dart';

class LoopScoutScreen extends ConsumerWidget {
  const LoopScoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puzzlesAsync = ref.watch(loopPuzzlesProvider);
    final loopState = ref.watch(loopScoutControllerProvider);
    final loopController = ref.read(loopScoutControllerProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Loop Scout')),
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
                      'We could not load loop challenges right now.',
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
                'No loop challenges available right now.',
                style: textTheme.bodyLarge,
              ),
            );
          }

          final validPuzzles = puzzles
              .where((puzzle) => puzzle.hasRequiredPromptFields)
              .toList(growable: false);
          if (validPuzzles.isEmpty) {
            return Center(
              child: Text(
                'No valid loop challenges available right now.',
                style: textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            );
          }

          final currentPuzzle =
              validPuzzles[loopState.currentPuzzleIndex % validPuzzles.length];

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Loop tracing',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${validPuzzles.length} challenge(s) loaded.',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
              if (validPuzzles.length != puzzles.length) ...[
                const SizedBox(height: 4),
                Text(
                  'Some malformed challenges were skipped.',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
              const SizedBox(height: 4),
              Text(
                'Retry pool: ${loopState.retryPuzzleIds.length}',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.75),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () =>
                        loopController.moveToRandomPuzzle(validPuzzles.length),
                    icon: const Icon(Icons.shuffle_rounded),
                    label: const Text('Random'),
                  ),
                  const SizedBox(width: 10),
                  FilledButton.icon(
                    onPressed: () =>
                        loopController.moveToNextPuzzle(validPuzzles.length),
                    icon: const Icon(Icons.skip_next_rounded),
                    label: const Text('Next Challenge'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CodeDisplayBox(snippet: currentPuzzle.snippet),
              const SizedBox(height: 12),
              LoopInputPanel(
                key: ValueKey('loop-input-panel-${currentPuzzle.id}'),
                puzzleId: currentPuzzle.id,
                targetVariable: currentPuzzle.target,
                correctAnswer: currentPuzzle.answer,
              ),
            ],
          );
        },
      ),
    );
  }
}
