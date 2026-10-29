import 'package:superiper_app/models/loyalty_card.dart';

import 'card_database.dart';

class CardRepository {
  final CardDatabase _database;

  CardRepository({CardDatabase? database})
    : _database = database ?? CardDatabase.instance;

  Future<List<LoyaltyCard>> getAll() async {
    final db = await _database.database;
    final rows = await db.query('cards', orderBy: 'created_at DESC');

    return rows
        .map(
          (r) => LoyaltyCard(
            name: r['name'] as String,
            code: r['barcode'] as String,
            barcodeFormat: r['barcode_format'] as String,
            category: r['category'] as String,
            holder: r['holder'] as String,
            isFavorite: (r['is_favorite'] as int) == 1,
          ),
        )
        .toList();
  }

  Map<String, Object?> _values(LoyaltyCard c) => {
    'name': c.name,
    'barcode': c.code,
    'barcode_format': c.barcodeFormat,
    'category': c.category,
    'holder': c.holder,
    'is_favorite': c.isFavorite ? 1 : 0,
  };

  Future<void> insert(LoyaltyCard card) async {
    final db = await _database.database;
    await db.insert('cards', {
      ..._values(card),
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> update(String originalCode, LoyaltyCard card) async {
    final db = await _database.database;
    await db.update(
      'cards',
      _values(card),
      where: 'barcode = ?',
      whereArgs: [originalCode],
    );
  }

  Future<void> delete(String code) async {
    final db = await _database.database;
    await db.delete('cards', where: 'barcode = ?', whereArgs: [code]);
  }
}
