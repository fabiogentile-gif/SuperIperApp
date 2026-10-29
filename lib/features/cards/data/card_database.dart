import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class CardDatabase {
  CardDatabase._();

  static final CardDatabase instance = CardDatabase._();

  static const String _databaseName = 'ards.db';
  static const int _databaseVersion = 2;

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
        category TEXT NOT NULL DEFAULT 'Spesa',
        holder TEXT NOT NULL DEFAULT '',
        is_favorite INTEGER NOT NULL DEFAULT 0,
        UNIQUE(barcode, barcode_format)
      )
    ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            "ALTER TABLE cards ADD COLUMN holder TEXT NOT NULL DEFAULT ''",
          );
          await db.execute(
            'ALTER TABLE cards ADD COLUMN is_favorite INTEGER NOT NULL DEFAULT 0',
          );
        }
      },
    );

    return _database!;
  }
}
