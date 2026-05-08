import 'package:flutter/material.dart';

import '../../models/error_detection_challenge.dart';
import '../../providers/error_detection_controller.dart';
import '../selectable_code_block.dart';

class ErrorDetectionChallengeView extends StatelessWidget {
  const ErrorDetectionChallengeView({
    required this.challenge,
    required this.state,
    required this.lineNumberController,
    required this.lineNumberError,
    required this.onLineSelected,
    required this.onSubmit,
    required this.onNext,
    super.key,
  });

  final ErrorDetectionChallenge challenge;
  final ErrorDetectionState state;
  final TextEditingController lineNumberController;
  final String? lineNumberError;
  final ValueChanged<int> onLineSelected;
  final VoidCallback onSubmit;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final correctLineNumber = challenge.errorLine + 1;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Find the bug',
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          'Difficulty: ${challenge.difficulty}',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.75),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Tags: ${challenge.tags.isEmpty ? 'None' : challenge.tags.join(', ')}',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.75),
          ),
        ),
        const SizedBox(height: 12),
        SelectableCodeBlock(
          key: ValueKey('selectable-code-block-${challenge.id}'),
          snippet: challenge.snippet,
          selectedLineIndex: state.selectedLineIndex,
          hasSubmitted: state.hasSubmitted,
          isCorrect: state.isCorrect,
          correctLineIndex: challenge.errorLine,
          onLineSelected: onLineSelected,
        ),
        const SizedBox(height: 12),
        TextField(
          key: const ValueKey('error-line-number-field'),
          controller: lineNumberController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: 'Line number',
            hintText: 'Enter 1-${challenge.snippet.split('\n').length}',
            errorText: lineNumberError,
          ),
          onSubmitted: (_) => onSubmit(),
        ),
        const SizedBox(height: 12),
        Text(
          _submissionMessage(correctLineNumber),
          key: const ValueKey('error-detection-feedback'),
          style: textTheme.bodyMedium?.copyWith(
            color: _submissionColor(colorScheme),
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
                  Text(challenge.target, style: textTheme.bodyMedium),
                  if (challenge.answer.trim().isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      challenge.answer,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.9),
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
            FilledButton(onPressed: onSubmit, child: const Text('Submit')),
            const SizedBox(width: 10),
            OutlinedButton(onPressed: onNext, child: const Text('Next')),
          ],
        ),
      ],
    );
  }

  String _submissionMessage(int correctLineNumber) {
    if (!state.hasSubmitted || state.isCorrect == null) {
      return 'Enter the line number with the error, then submit.';
    }
    return state.isCorrect!
        ? 'Correct! The error is on line $correctLineNumber.'
        : 'Not quite. The error is on line $correctLineNumber.';
  }

  Color _submissionColor(ColorScheme colorScheme) {
    if (!state.hasSubmitted || state.isCorrect == null) {
      return colorScheme.onSurface.withValues(alpha: 0.8);
    }
    return state.isCorrect!
        ? Colors.green.shade300
        : colorScheme.error.withValues(alpha: 0.9);
  }
}
