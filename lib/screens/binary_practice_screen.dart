import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/binary_practice_config.dart';
import '../providers/binary_practice_provider.dart';
import '../widgets/binary/binary_visibility_settings_card.dart';
import '../widgets/binary/bit_toggle_tile.dart';

class BinaryPracticeScreen extends ConsumerStatefulWidget {
  const BinaryPracticeScreen({super.key});

  @override
  ConsumerState<BinaryPracticeScreen> createState() =>
      _BinaryPracticeScreenState();
}

class _BinaryPracticeScreenState extends ConsumerState<BinaryPracticeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(binaryPracticeProvider.notifier).restoreDisplayPreferences();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(binaryPracticeProvider);
    final controller = ref.read(binaryPracticeProvider.notifier);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

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
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Flip the ${BinaryPracticeConfig.bitCount} bits to match the target number.',
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
            children: List.generate(BinaryPracticeConfig.placeValues.length, (
              index,
            ) {
              return BitToggleTile(
                index: index,
                bitValue: BinaryPracticeConfig.placeValues[index],
                isOn: state.bits[index],
                showBitPlaceValues: state.showBitPlaceValues,
                onTap: () => controller.toggleBit(index),
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
          BinaryVisibilitySettingsCard(
            showCurrentValue: state.showCurrentValue,
            showBitPlaceValues: state.showBitPlaceValues,
            onShowCurrentValueChanged: controller.toggleShowCurrentValue,
            onShowBitPlaceValuesChanged: controller.toggleShowBitPlaceValues,
          ),
        ],
      ),
    );
  }
}
