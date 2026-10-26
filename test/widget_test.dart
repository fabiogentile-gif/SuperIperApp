import 'package:flutter_test/flutter_test.dart';
import 'package:superiper_app/providers/card_provider.dart';

void main() {
  test('updateCard changes the saved card data', () {
    final provider = CardProvider();
    final original = provider.cards.first;

    provider.updateCard(
      original.code,
      name: 'Lidl',
      code: '9999 8888 7777 66',
      category: 'Supermercato',
      holder: 'Luigi Verdi',
    );

    final updated = provider.cards.firstWhere((card) => card.name == 'Lidl');
    expect(updated.code, '9999 8888 7777 66');
    expect(updated.category, 'Supermercato');
    expect(updated.holder, 'Luigi Verdi');
  });
}
