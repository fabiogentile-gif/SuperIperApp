import 'package:flutter/material.dart';
import 'package:superiper_app/theme/theme_controller.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeMode,
      builder: (context, mode, _) {
        return SizedBox(
          width: double.infinity,
          child: SegmentedButton<ThemeMode>(
            showSelectedIcon: false,
            style: SegmentedButton.styleFrom(
              selectedBackgroundColor: cs.primaryContainer,
              selectedForegroundColor: cs.primary,
            ),
            segments: const [
              ButtonSegment(
                value: ThemeMode.system,
                label: Text('Sistema'),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                label: Text('Scuro'),
              ),
              ButtonSegment(
                value: ThemeMode.light,
                label: Text('Chiaro'),
              ),
            ],
            selected: {mode},
            onSelectionChanged: (s) => themeMode.value = s.first,
          ),
        );
      },
    );
  }
}
