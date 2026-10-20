import 'package:flutter/material.dart';
import 'package:superiper_app/theme/theme_controller.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final temaScuro = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 20),
            child: Text(
              'Tema chiaro / scuro',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),

          SwitchListTile(
            secondary: Icon(
              temaScuro ? Icons.dark_mode : Icons.light_mode,
              size: 20,
            ),

            title: const Text('Tema scuro'),

            subtitle: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 14,
                ),
                children: [
                  TextSpan(text: temaScuro ? 'Dark' : 'Light'),
                  const TextSpan(text: ' theme attivo'),
                ],
              ),
            ),

            value: temaScuro,

            onChanged: (v) => themeMode.value = v ? ThemeMode.dark : ThemeMode.light,
          ),
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ciao dal tema!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight(600),
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'I colori arrivano da Theme.of(context).colorScheme \nCambia lo switch e guarda AppBar,Pulsanti e cards',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
          //Pulsante primary
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 5),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                side: BorderSide(
                  color: Theme.of(context).colorScheme.onSecondary,
                  width: 2,
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () {},
              child: Text('Pulsante filled (usa primary)'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.surface,
                foregroundColor: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () {},
              child: Text('Pulsante filled (usa primary)'),
            ),
          ),
        ],
      ),
    );
  }
}
