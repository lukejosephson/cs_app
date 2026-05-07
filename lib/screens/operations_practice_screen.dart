import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/operations_practice_controller.dart';
import '../providers/operations_practice_provider.dart';
import '../widgets/code_display_box.dart';
import '../widgets/operations_input_panel.dart';

final operationsRandomProvider = Provider<Random>((ref) => Random());

class OperationsPracticeScreen extends ConsumerStatefulWidget {
  const OperationsPracticeScreen({super.key});

  @override
  ConsumerState<OperationsPracticeScreen> createState() =>
      _OperationsPracticeScreenState();
}

class _OperationsPracticeScreenState
    extends ConsumerState<OperationsPracticeScreen> {
  int _currentPuzzleIndex = 0;

  int _nextRandomPuzzleIndex(int puzzleCount) {
    if (puzzleCount <= 1) {
      return 0;
    }

    final random = ref.read(operationsRandomProvider);
    var nextIndex = _currentPuzzleIndex;
    while (nextIndex == _currentPuzzleIndex) {
      nextIndex = random.nextInt(puzzleCount);
    }
    return nextIndex;
  }

  @override
  Widget build(BuildContext context) {
    final puzzlesAsync = ref.watch(operationsPracticeProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Operations Practice')),
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

          final currentPuzzle =
              validPuzzles[_currentPuzzleIndex % validPuzzles.length];

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
              FilledButton.icon(
                onPressed: () {
                  setState(() {
                    _currentPuzzleIndex = _nextRandomPuzzleIndex(
                      validPuzzles.length,
                    );
                  });
                  ref
                      .read(operationsPracticeControllerProvider.notifier)
                      .reset();
                },
                icon: const Icon(Icons.skip_next_rounded),
                label: const Text('Next Challenge'),
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
