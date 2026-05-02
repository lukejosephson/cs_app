import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/error_detection_controller.dart';
import '../providers/error_detection_provider.dart';
import '../widgets/selectable_code_block.dart';

class ErrorDetectionScreen extends ConsumerStatefulWidget {
  const ErrorDetectionScreen({super.key});

  @override
  ConsumerState<ErrorDetectionScreen> createState() =>
      _ErrorDetectionScreenState();
}

class _ErrorDetectionScreenState extends ConsumerState<ErrorDetectionScreen> {
  int _currentPuzzleIndex = 0;

  @override
  Widget build(BuildContext context) {
    final puzzlesAsync = ref.watch(errorDetectionProvider);
    final state = ref.watch(errorDetectionControllerProvider);
    final controller = ref.read(errorDetectionControllerProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Error Detection')),
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
                      'We could not load error detection challenges.',
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
                'No error detection challenges available right now.',
                style: textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            );
          }

          final currentPuzzle = puzzles[_currentPuzzleIndex % puzzles.length];

          String submissionMessage() {
            if (!state.hasSubmitted || state.isCorrect == null) {
              return 'Tap a line, then submit your choice.';
            }
            return state.isCorrect!
                ? 'Correct! Nice catch.'
                : 'Not quite. Green shows the correct line.';
          }

          Color submissionColor() {
            if (!state.hasSubmitted || state.isCorrect == null) {
              return colorScheme.onSurface.withValues(alpha: 0.8);
            }
            return state.isCorrect!
                ? Colors.green.shade300
                : colorScheme.error.withValues(alpha: 0.9);
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Find the bug',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${puzzles.length} challenge(s) loaded.',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 4),
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
              SelectableCodeBlock(
                key: ValueKey('selectable-code-block-${currentPuzzle.id}'),
                snippet: currentPuzzle.snippet,
                selectedLineIndex: state.selectedLineIndex,
                hasSubmitted: state.hasSubmitted,
                isCorrect: state.isCorrect,
                correctLineIndex: currentPuzzle.errorLine,
                onLineSelected: controller.selectLine,
              ),
              const SizedBox(height: 12),
              Text(
                submissionMessage(),
                key: const ValueKey('error-detection-feedback'),
                style: textTheme.bodyMedium?.copyWith(
                  color: submissionColor(),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  FilledButton(
                    onPressed: () =>
                        controller.checkSelection(currentPuzzle.errorLine),
                    child: const Text('Submit'),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _currentPuzzleIndex = (_currentPuzzleIndex + 1) %
                            puzzles.length;
                      });
                      ref.invalidate(errorDetectionControllerProvider);
                    },
                    child: const Text('Next'),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
