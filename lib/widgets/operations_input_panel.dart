import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/operations_practice_controller.dart';

class OperationsInputPanel extends ConsumerStatefulWidget {
  const OperationsInputPanel({
    required this.puzzleId,
    required this.targetPrompt,
    required this.correctAnswer,
    super.key,
  });

  final int puzzleId;
  final String targetPrompt;
  final String correctAnswer;

  @override
  ConsumerState<OperationsInputPanel> createState() =>
      _OperationsInputPanelState();
}

class _OperationsInputPanelState extends ConsumerState<OperationsInputPanel> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void didUpdateWidget(covariant OperationsInputPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.puzzleId != oldWidget.puzzleId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        ref.read(operationsPracticeControllerProvider.notifier).reset();
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(operationsPracticeControllerProvider.notifier);
    final state = ref.watch(operationsPracticeControllerProvider);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    if (_textController.text != state.currentInput) {
      _textController.value = _textController.value.copyWith(
        text: state.currentInput,
        selection: TextSelection.collapsed(offset: state.currentInput.length),
        composing: TextRange.empty,
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Target: ${widget.targetPrompt}',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const ValueKey('operations-answer-input'),
              controller: _textController,
              onChanged: controller.updateInput,
              decoration: const InputDecoration(
                labelText: 'Your answer',
                hintText: 'Enter your final output/value',
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              key: const ValueKey('operations-check-answer-button'),
              onPressed: () => controller.checkAnswer(
                puzzleId: widget.puzzleId,
                correctAnswer: widget.correctAnswer,
              ),
              child: const Text('Check Answer'),
            ),
            if (state.hasSubmitted) ...[
              const SizedBox(height: 12),
              Text(
                state.isCorrect == true
                    ? 'Success! Correct answer.'
                    : 'Not quite. Correct answer: ${widget.correctAnswer}',
                style: textTheme.bodyMedium?.copyWith(
                  color: state.isCorrect == true
                      ? Colors.green.shade300
                      : colorScheme.error,
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
