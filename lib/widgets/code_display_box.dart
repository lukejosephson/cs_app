import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CodeDisplayBox extends StatelessWidget {
  const CodeDisplayBox({required this.snippet, super.key});

  final String snippet;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F162A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.35),
        ),
      ),
      child: SelectableText(
        snippet,
        style: GoogleFonts.firaCode(
          fontSize: 14,
          height: 1.5,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }
}
