import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelperFavorite {
  static const _databaseName = "product_database.db";
  static const _databaseVersion = 1;
  static const table = 'products';
  static const columnId = 'id';
  static const columnTitle = 'title';
  static const columnPrice = 'price';
  static const columnDescription = 'description';
  static const columnCategory = 'category';
  static const columnImage = 'image';
  static const columnRatingRate = 'rating_rate';
  static const columnRatingCount = 'rating_count';

  // Singleton pattern
  DatabaseHelperFavorite._privateConstructor();
  static final DatabaseHelperFavorite instance =
      DatabaseHelperFavorite._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnTitle TEXT NOT NULL,
            $columnPrice REAL NOT NULL,
            $columnDescription TEXT NOT NULL,
            $columnCategory TEXT NOT NULL,
            $columnImage TEXT NOT NULL,
            $columnRatingRate REAL NOT NULL,
            $columnRatingCount INTEGER NOT NULL
          )
          ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'))!;
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<bool> isFavorite(int id) async {
    Database db = await instance.database;
    var result = await db.query(table, where: '$columnId = ?', whereArgs: [id]);
    return result.isNotEmpty;
  }
}
