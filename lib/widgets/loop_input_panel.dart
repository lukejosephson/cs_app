import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/loop_tracing_provider.dart';

class LoopInputPanel extends ConsumerStatefulWidget {
  const LoopInputPanel({
    required this.puzzleId,
    required this.targetVariable,
    required this.correctAnswer,
    super.key,
  });

  final int puzzleId;
  final String targetVariable;
  final String correctAnswer;

  @override
  ConsumerState<LoopInputPanel> createState() => _LoopInputPanelState();
}

class _LoopInputPanelState extends ConsumerState<LoopInputPanel> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void didUpdateWidget(covariant LoopInputPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.puzzleId != oldWidget.puzzleId) {
      ref.read(loopScoutControllerProvider.notifier).clearResponse();
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(loopScoutControllerProvider.notifier);
    final state = ref.watch(loopScoutControllerProvider);
    final textTheme = Theme.of(context).textTheme;

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
              'Target variable: ${widget.targetVariable}',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const ValueKey('loop-answer-input'),
              controller: _textController,
              onChanged: controller.updateInput,
              decoration: const InputDecoration(
                labelText: 'Your answer',
                hintText: 'Enter final value',
                helperText: 'Case and extra spaces are ignored.',
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              key: const ValueKey('loop-check-answer-button'),
              onPressed: () => controller.submitAnswer(widget.correctAnswer),
              child: const Text('Check Answer'),
            ),
            if (state.inputErrorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                state.inputErrorMessage!,
                style: textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            if (state.hasSubmitted) ...[
              const SizedBox(height: 12),
              Text(
                state.isCorrect
                    ? 'Success! Correct answer.'
                    : 'Not quite. Correct answer: ${widget.correctAnswer}',
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
