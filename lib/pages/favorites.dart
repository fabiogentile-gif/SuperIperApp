import 'package:flutter/material.dart';
import 'package:superiper_app/providers/card_provider.dart';
import 'package:superiper_app/widgets/app_bar.dart';
import 'package:superiper_app/widgets/homepage/card_grid.dart';

class Favorites extends StatelessWidget {
  final CardProvider cardProvider;

  const Favorites({super.key, required this.cardProvider});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const StandardAppBar(
        title: 'Preferiti',
        subtitle: 'Le carte che usi di più',
      ),
      body: ListenableBuilder(
        listenable: cardProvider,
        builder: (context, _) {
          final favorites = cardProvider.favorites;
          if (favorites.isEmpty) {
            return Center(
              child: Text(
                'Nessun preferito',
                style: TextStyle(fontSize: 16, color: colors.onSurfaceVariant),
              ),
            );
          }
          return CardGrid(cards: favorites, cardProvider: cardProvider);
        },
      ),
    );
  }
}