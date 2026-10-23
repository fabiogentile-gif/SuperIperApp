import 'package:flutter/material.dart';
import 'package:superiper_app/widgets/app_bar.dart';
import 'package:superiper_app/widgets/settings/brightness_selector.dart';
import 'package:superiper_app/widgets/settings/setting_group.dart';
import 'package:superiper_app/widgets/settings/setting_tile.dart';
import 'package:superiper_app/widgets/settings/theme_selector.dart';
import 'package:superiper_app/widgets/settings/default_holder_selector.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: StandardAppBar(
        title: 'Impostazioni',
        subtitle: 'Personalizza l\'aspetto e il comportamento dell\'app',
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
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
                      icon: Icons.palette_outlined,
                      columnChild: ThemeSelector(),
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
                      title: 'Luminosità automatica',
                      subtitle: 'Aumenta quando mostri una carta',
                      icon: Icons.wb_sunny_outlined,
                      rowChild: BrightnessSelector(),
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
                  'Preferenze',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const SettingsGroup(
                  children: [
                    SettingTile(
                      title: 'Intestatario predefinito',
                      subtitle: 'Per le nuove carte salvate',
                      icon: Icons.person_outline,
                      rowChild: DefaultHolderSelector(),
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
                  'Informazioni sull\'app',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
