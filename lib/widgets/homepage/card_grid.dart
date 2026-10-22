
import 'package:flutter/material.dart';
import 'card_tile.dart';

class CardGrid extends StatelessWidget {
  final List<String> cards;

  const CardGrid({
    super.key,
    required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (cards.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text(
            'Nessuna carta trovata',
            style: TextStyle(
              color: colors.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          mainAxisExtent: 110,
        ),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          return CardTile(name: cards[index],code: '12344',);
        },
      ),
    );
  }
}
