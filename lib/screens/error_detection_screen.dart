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
  late final TextEditingController _lineNumberController;
  String? _lineNumberError;

  @override
  void initState() {
    super.initState();
    _lineNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _lineNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final puzzlesAsync = ref.watch(errorDetectionPuzzlesProvider);
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
          final maxLineNumber = currentPuzzle.snippet.split('\n').length;
          final correctLineNumber = currentPuzzle.errorLine + 1;

          void submitSelection() {
            final parsedLineNumber = int.tryParse(
              _lineNumberController.text.trim(),
            );
            if (parsedLineNumber == null ||
                parsedLineNumber < 1 ||
                parsedLineNumber > maxLineNumber) {
              setState(() {
                _lineNumberError =
                    'Enter a valid line number from 1 to $maxLineNumber.';
              });
              return;
            }

            setState(() {
              _lineNumberError = null;
            });
            controller.selectLineNumber(parsedLineNumber);
            controller.checkSelection(currentPuzzle.errorLine);
          }

          String submissionMessage() {
            if (!state.hasSubmitted || state.isCorrect == null) {
              return 'Enter the line number with the error, then submit.';
            }
            return state.isCorrect!
                ? 'Correct! The error is on line $correctLineNumber.'
                : 'Not quite. The error is on line $correctLineNumber.';
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
                onLineSelected: (index) {
                  controller.selectLine(index);
                  _lineNumberController.text = '${index + 1}';
                  if (_lineNumberError != null) {
                    setState(() {
                      _lineNumberError = null;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              TextField(
                key: const ValueKey('error-line-number-field'),
                controller: _lineNumberController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: 'Line number',
                  hintText: 'Enter 1-$maxLineNumber',
                  errorText: _lineNumberError,
                ),
                onSubmitted: (_) => submitSelection(),
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
              if (state.hasSubmitted) ...[
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Error explanation',
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(currentPuzzle.target, style: textTheme.bodyMedium),
                        if (currentPuzzle.answer.trim().isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            currentPuzzle.answer,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.9,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  FilledButton(
                    onPressed: submitSelection,
                    child: const Text('Submit'),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _currentPuzzleIndex =
                            (_currentPuzzleIndex + 1) % puzzles.length;
                        _lineNumberController.clear();
                        _lineNumberError = null;
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
