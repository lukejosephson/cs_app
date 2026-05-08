import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/error_detection_controller.dart';
import '../providers/error_detection_provider.dart';
import '../widgets/error_detection/error_detection_challenge_view.dart';

final errorDetectionLineNumberErrorProvider =
    StateProvider.autoDispose<String?>((ref) => null);

class ErrorDetectionScreen extends ConsumerStatefulWidget {
  const ErrorDetectionScreen({super.key});

  @override
  ConsumerState<ErrorDetectionScreen> createState() =>
      _ErrorDetectionScreenState();
}

class _ErrorDetectionScreenState extends ConsumerState<ErrorDetectionScreen> {
  late final TextEditingController _lineNumberController;

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
    final lineNumberError = ref.watch(errorDetectionLineNumberErrorProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Error Detection')),
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
                'No error detection challenges available right now.',
                style: textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            );
          }

          final currentPuzzle =
              puzzles[state.currentPuzzleIndex % puzzles.length];
          final maxLineNumber = currentPuzzle.snippet.split('\n').length;

          void submitSelection() {
            final parsedLineNumber = int.tryParse(
              _lineNumberController.text.trim(),
            );
            if (parsedLineNumber == null ||
                parsedLineNumber < 1 ||
                parsedLineNumber > maxLineNumber) {
              ref.read(errorDetectionLineNumberErrorProvider.notifier).state =
                  'Enter a valid line number from 1 to $maxLineNumber.';
              return;
            }

            ref.read(errorDetectionLineNumberErrorProvider.notifier).state =
                null;
            controller.selectLineNumber(parsedLineNumber);
            controller.checkSelection(
              puzzleId: currentPuzzle.id,
              correctLineIndex: currentPuzzle.errorLine,
            );
          }

          return ErrorDetectionChallengeView(
            challenge: currentPuzzle,
            state: state,
            lineNumberController: _lineNumberController,
            lineNumberError: lineNumberError,
            onLineSelected: (index) {
              controller.selectLine(index);
              _lineNumberController.text = '${index + 1}';
              if (lineNumberError != null) {
                ref.read(errorDetectionLineNumberErrorProvider.notifier).state =
                    null;
              }
            },
            onSubmit: submitSelection,
            onNext: () {
              controller.moveToNextPuzzle(puzzles);
              _lineNumberController.clear();
              ref.read(errorDetectionLineNumberErrorProvider.notifier).state =
                  null;
            },
          );
        },
      ),
    );
  }
}
