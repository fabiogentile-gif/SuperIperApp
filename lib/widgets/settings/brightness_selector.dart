import 'package:flutter/material.dart';
import 'package:superiper_app/widgets/settings/utils/brightness.dart';

class BrightnessSelector extends StatelessWidget {
  const BrightnessSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: autoMaxBrightness,
      builder: (context, enabled, _) {
        return Switch(
          value: enabled,
          onChanged: (v) => autoMaxBrightness.value = v,
        );
      },
    );
  }
}
