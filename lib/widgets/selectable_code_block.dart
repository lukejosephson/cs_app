import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectableCodeBlock extends StatelessWidget {
  const SelectableCodeBlock({
    required this.snippet,
    required this.selectedLineIndex,
    required this.hasSubmitted,
    required this.isCorrect,
    required this.correctLineIndex,
    required this.onLineSelected,
    super.key,
  });

  final String snippet;
  final int? selectedLineIndex;
  final bool hasSubmitted;
  final bool? isCorrect;
  final int correctLineIndex;
  final ValueChanged<int> onLineSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final lines = snippet.split('\n');

    Color lineTint(int index) {
      final isSelected = selectedLineIndex == index;
      if (!hasSubmitted) {
        return isSelected
            ? colorScheme.primary.withValues(alpha: 0.18)
            : Colors.transparent;
      }

      if ((isCorrect ?? false) && isSelected) {
        return Colors.green.withValues(alpha: 0.24);
      }
      if (!(isCorrect ?? false) && isSelected) {
        return colorScheme.error.withValues(alpha: 0.24);
      }
      if (!(isCorrect ?? false) && index == correctLineIndex) {
        return Colors.green.withValues(alpha: 0.24);
      }
      return Colors.transparent;
    }

    Color lineBorder(int index) {
      final isSelected = selectedLineIndex == index;
      if (!hasSubmitted) {
        return isSelected
            ? colorScheme.primary.withValues(alpha: 0.45)
            : Colors.transparent;
      }
      if ((isCorrect ?? false) && isSelected) {
        return Colors.green.withValues(alpha: 0.65);
      }
      if (!(isCorrect ?? false) && isSelected) {
        return colorScheme.error.withValues(alpha: 0.65);
      }
      if (!(isCorrect ?? false) && index == correctLineIndex) {
        return Colors.green.withValues(alpha: 0.65);
      }
      return Colors.transparent;
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0F162A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(lines.length, (index) {
          final lineNumber = index + 1;
          final line = lines[index];
          return InkWell(
            key: ValueKey('error-line-$index'),
            onTap: () => onLineSelected(index),
            child: Container(
              decoration: BoxDecoration(
                color: lineTint(index),
                border: Border(
                  left: BorderSide(width: 3, color: lineBorder(index)),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 28,
                    child: Text(
                      '$lineNumber',
                      style: GoogleFonts.firaCode(
                        fontSize: 13,
                        height: 1.5,
                        color: colorScheme.onSurface.withValues(alpha: 0.55),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      line,
                      style: GoogleFonts.firaCode(
                        fontSize: 14,
                        height: 1.5,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
