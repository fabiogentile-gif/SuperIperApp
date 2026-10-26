import 'package:flutter/material.dart';
import 'package:superiper_app/theme/theme_controller.dart';
import 'package:superiper_app/widgets/segments.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  static const double _gap = 4;

  static const _options = [
    (
      mode: ThemeMode.system,
      label: 'Sistema',
      icon: Icons.brightness_auto_outlined,
      size: 17.0,
    ),
    (
      mode: ThemeMode.dark,
      label: 'Scuro',
      icon: Icons.dark_mode_outlined,
      size: 16.0,
    ),
    (
      mode: ThemeMode.light,
      label: 'Chiaro',
      icon: Icons.light_mode_outlined,
      size: 16.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeMode,
      builder: (context, mode, _) {
        return Container(
          width: double.infinity,
          height: 48,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < _options.length; i++) ...[
                if (i > 0) const SizedBox(width: _gap),
                Expanded(
                  child: Segment(
                    label: _options[i].label,
                    icon: _options[i].icon,
                    iconSize: _options[i].size,
                    selected: mode == _options[i].mode,
                    onTap: () => themeMode.value = _options[i].mode,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}


