import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/loop_strings.dart';
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
      appBar: AppBar(title: const Text(LoopStrings.screenTitle)),
      body: puzzlesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(height: 8),
              Text(
                'Unable to load puzzles. Please check your connection.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        data: (puzzles) {
          if (puzzles.isEmpty) {
            return Center(
              child: Text(
                LoopStrings.noChallengesAvailable,
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
                LoopStrings.noValidChallengesAvailable,
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
                LoopStrings.sectionTitle,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              if (validPuzzles.length != puzzles.length) ...[
                const SizedBox(height: 4),
                Text(
                  LoopStrings.malformedChallengesSkipped,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
              const SizedBox(height: 4),
              Text(
                LoopStrings.retryPoolCount(loopState.retryPuzzleIds.length),
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.75),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                LoopStrings.difficultyLabel(currentPuzzle.difficulty),
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.75),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                LoopStrings.tagsLabel(currentPuzzle.tags),
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
                    label: const Text(LoopStrings.randomButton),
                  ),
                  const SizedBox(width: 10),
                  FilledButton.icon(
                    onPressed: () => loopController.moveToNextPuzzle(validPuzzles),
                    icon: const Icon(Icons.skip_next_rounded),
                    label: const Text(LoopStrings.nextChallengeButton),
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
