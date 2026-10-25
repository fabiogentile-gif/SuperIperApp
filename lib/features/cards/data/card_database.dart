import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class CardDatabase {
  CardDatabase._();

  static final CardDatabase instance = CardDatabase._();

  static const String _databaseName = 'ards.db';
  static const int _databaseVersion = 1;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    final directory = await getDatabasesPath();
    final databasePath = p.join(directory, _databaseName);

    _database = await openDatabase(
      databasePath,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE cards (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            barcode TEXT NOT NULL,
            barcode_format TEXT NOT NULL,
            created_at TEXT NOT NULL,
            category TEXT NOT NULL DEFAULT 'Supermercato',
            UNIQUE(barcode, barcode_format)
          )
        ''');
      },
    );

    return _database!;
  }
}
