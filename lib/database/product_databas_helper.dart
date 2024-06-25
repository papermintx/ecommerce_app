import 'package:e_apps/models/product_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "products.db";
  static const _databaseVersion = 1;

  // Membuat singleton untuk memastikan hanya ada satu instance database
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Method untuk inisialisasi database
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // Method untuk membuat tabel saat database pertama kali dibuat
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE products (
            id INTEGER PRIMARY KEY,
            title TEXT NOT NULL,
            price REAL NOT NULL,
            description TEXT NOT NULL,
            category TEXT NOT NULL,
            image TEXT NOT NULL,
            rating_rate REAL NOT NULL, -- Untuk rate dari rating
            rating_count INTEGER NOT NULL, -- Untuk count dari rating
            isFavorite INTEGER DEFAULT 0,
            isCart INTEGER DEFAULT 0,
            quantity INTEGER DEFAULT 1,
            isCheckout INTEGER DEFAULT 0        
          )
          ''');
  }

  // Method untuk menyimpan data produk ke database
  Future<int> insertProduct(ProductModel product) async {
    Database db = await instance.database;
    return await db.insert('products', {
      'id': product.id,
      'title': product.title,
      'price': product.price,
      'description': product.description,
      'category': product.category,
      'image': product.image,
      'rating_rate': product.rating.rate,
      'rating_count': product.rating.count,
      'isFavorite': product.isFavorite ? 1 : 0,
      'isCart': product.isCart ? 1 : 0,
      'quantity': product.quantity,
      'isCheckout': product.isCheckout ? 1 : 0,
    });
  }

  Future<ProductModel> queryProduct(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query('products',
        columns: [
          'id',
          'title',
          'price',
          'description',
          'category',
          'image',
          'rating_rate',
          'rating_count',
          'isFavorite',
          'isCart',
          'quantity',
          'isCheckout'
        ],
        where: 'id = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return ProductModel(
        id: maps[0]['id'],
        title: maps[0]['title'],
        price: maps[0]['price'],
        description: maps[0]['description'],
        category: maps[0]['category'],
        image: maps[0]['image'],
        rating: Rating(
          rate: maps[0]['rating_rate'],
          count: maps[0]['rating_count'],
        ),
        isFavorite: maps[0]['isFavorite'] == 1,
        isCart: maps[0]['isCart'] == 1,
        quantity: maps[0]['quantity'],
        isCheckout: maps[0]['isCheckout'] == 1,
      );
    } else {
      throw Exception('Product not found');
    }
  }

  // Method untuk mengambil semua data produk dari database
  Future<List<Map<String, dynamic>>> queryAllProducts() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query('products');
    return maps;
  }

  // method untuk update data produk
  Future<int> updateProduct(ProductModel product) async {
    Database db = await instance.database;
    return await db.update(
        'products',
        {
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'category': product.category,
          'image': product.image,
          'rating_rate': product.rating.rate,
          'rating_count': product.rating.count,
          'isFavorite': product.isFavorite ? 1 : 0,
          'isCart': product.isCart ? 1 : 0,
          'quantity': product.quantity,
          'isCheckout': product.isCheckout ? 1 : 0,
        },
        where: 'id = ?',
        whereArgs: [product.id]);
  }
}
