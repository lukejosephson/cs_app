import 'package:flutter/material.dart';

class BitToggleTile extends StatelessWidget {
  const BitToggleTile({
    required this.index,
    required this.bitValue,
    required this.isOn,
    required this.showBitPlaceValues,
    required this.onTap,
    super.key,
  });

  final int index;
  final int bitValue;
  final bool isOn;
  final bool showBitPlaceValues;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showBitPlaceValues)
          Text(
            '$bitValue',
            style: textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.75),
            ),
          ),
        SizedBox(height: showBitPlaceValues ? 6 : 22),
        InkWell(
          key: ValueKey('bit-toggle-$index'),
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isOn
                  ? Colors.green.shade600
                  : colorScheme.surfaceContainerHighest.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isOn
                    ? Colors.green.shade300
                    : colorScheme.outline.withValues(alpha: 0.4),
              ),
            ),
            child: Text(
              isOn ? '1' : '0',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
