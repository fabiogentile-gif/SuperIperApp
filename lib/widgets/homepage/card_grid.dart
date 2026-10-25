
import 'package:flutter/material.dart';
import 'card_tile.dart';

class CardGrid extends StatelessWidget {
  final List<Map<String, String>> cards;

  const CardGrid({
    super.key,
    required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (cards.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Nessuna carta trovata',
            style: TextStyle(
              color: colors.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          mainAxisExtent: 110,
        ),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards[index];
          return CardTile(
            name: card['name'] ?? 'Carta',
            code: card['code'] ?? '',
            icon: Icons.credit_card,
          );
        },
      ),
    );
  }
}
