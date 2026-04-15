import 'package:flutter/material.dart';

class BinaryVisibilitySettingsCard extends StatelessWidget {
  const BinaryVisibilitySettingsCard({
    required this.showCurrentValue,
    required this.showBitPlaceValues,
    required this.onShowCurrentValueChanged,
    required this.onShowBitPlaceValuesChanged,
    super.key,
  });

  final bool showCurrentValue;
  final bool showBitPlaceValues;
  final ValueChanged<bool> onShowCurrentValueChanged;
  final ValueChanged<bool> onShowBitPlaceValuesChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Show current value'),
            value: showCurrentValue,
            onChanged: onShowCurrentValueChanged,
          ),
          SwitchListTile(
            title: const Text('Show bit place values'),
            value: showBitPlaceValues,
            onChanged: onShowBitPlaceValuesChanged,
          ),
        ],
      ),
    );
  }
}
