import 'package:flutter/material.dart';
import 'package:superiper_app/widgets/settings/brightness_selector.dart';
import 'package:superiper_app/widgets/settings/setting_group.dart';
import 'package:superiper_app/widgets/settings/setting_tile.dart';
import 'package:superiper_app/widgets/settings/theme_selector.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 20),
            child: Text(
              'Impostazioni',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aspetto',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const SettingsGroup(
                  children: [
                    SettingTile(
                      title: 'Tema',
                      subtitle: 'Scegli l\'aspetto dell\'app',
                      child: ThemeSelector(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Carte',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const SettingsGroup(
                  children: [
                    SettingTile(
                      title: 'Tema',
                      subtitle: 'Scegli l\'aspetto dell\'app',
                      trailing: BrightnessSelector(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
