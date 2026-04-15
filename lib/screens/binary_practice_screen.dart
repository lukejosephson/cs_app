import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/binary_practice_provider.dart';

class BinaryPracticeScreen extends ConsumerWidget {
  const BinaryPracticeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(binaryPracticeProvider);
    final controller = ref.read(binaryPracticeProvider.notifier);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    const weights = [64, 32, 16, 8, 4, 2, 1];

    return Scaffold(
      appBar: AppBar(title: const Text('Binary Practice')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Target Number: ${state.targetNumber}',
                    style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Flip the seven bits to match the target number.',
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 6,
            runSpacing: 8,
            children: List.generate(weights.length, (index) {
              final isOn = state.bits[index];
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.showBitPlaceValues)
                    Text(
                      '${weights[index]}',
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.75),
                      ),
                    ),
                  SizedBox(height: state.showBitPlaceValues ? 6 : 22),
                  InkWell(
                    key: ValueKey('bit-toggle-$index'),
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => controller.toggleBit(index),
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
            }),
          ),
          if (state.showCurrentValue) ...[
            const SizedBox(height: 14),
            Text(
              'Your Value: ${state.currentValue}',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: controller.checkAnswer,
            icon: const Icon(Icons.check),
            label: const Text('Check Answer'),
          ),
          if (state.feedback != null) ...[
            const SizedBox(height: 16),
            Card(
              color: state.isCorrect == true
                  ? colorScheme.primary.withValues(alpha: 0.2)
                  : colorScheme.errorContainer.withValues(alpha: 0.85),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Text(
                  state.feedback!,
                  style: textTheme.bodyMedium?.copyWith(
                    color: state.isCorrect == true
                        ? colorScheme.onSurface
                        : colorScheme.onErrorContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Show current value'),
                  value: state.showCurrentValue,
                  onChanged: controller.toggleShowCurrentValue,
                ),
                SwitchListTile(
                  title: const Text('Show bit place values'),
                  value: state.showBitPlaceValues,
                  onChanged: controller.toggleShowBitPlaceValues,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
