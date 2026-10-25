import '../domain/card.dart';
import 'card_database.dart';

class CardRepository {
  final CardDatabase _database;

  CardRepository({CardDatabase? database})
      : _database = database ?? CardDatabase.instance;

  Future<int> save(Card card) async {
    final db = await _database.database;

    return db.insert(
      'cards',
      card.toMap()..remove('id'),
    );
  }

  Future<List<Card>> getAll() async {
    final db = await _database.database;

    final rows = await db.query(
      'cards',
      orderBy: 'created_at DESC',
    );

    return rows.map(Card.fromMap).toList();
  }

  Future<void> delete(int id) async {
    final db = await _database.database;

    await db.delete(
      'cards',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
