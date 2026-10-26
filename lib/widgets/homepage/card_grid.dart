import 'package:flutter/material.dart';
import 'package:superiper_app/models/loyalty_card.dart';
import 'package:superiper_app/providers/card_provider.dart';
import 'package:superiper_app/widgets/homepage/card_detail_sheet.dart';

import 'card_tile.dart';

class CardGrid extends StatelessWidget {
  final List<LoyaltyCard> cards;
  final CardProvider cardProvider;

  const CardGrid({
    super.key,
    required this.cards,
    required this.cardProvider,
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
            style: TextStyle(color: colors.onSurfaceVariant),
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
            name: card.name,
            icon: Icons.credit_card,
            onTap: () => showCardDetailsSheet(
              context,
              card,
              provider: cardProvider,
            ),
          );
        },
      ),
    );
  }
}