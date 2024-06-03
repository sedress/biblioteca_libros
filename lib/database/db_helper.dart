import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY, username TEXT, password TEXT)',
        );
        db.execute(
          'CREATE TABLE books(id INTEGER PRIMARY KEY, title TEXT, author TEXT, location TEXT, condition TEXT, genre TEXT, publication_date TEXT, availability TEXT, notes TEXT)',
        );
      },
    );
  }

  Future<void> insertUser(String username, String password) async {
    final db = await database;
    await db.insert(
      'users',
      {'username': username, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getUser(String username) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<void> insertBook(String title, String author, String location, String condition, String genre, String publicationDate, String availability, String notes) async {
    try {
      final db = await database;
      await db.insert(
        'books',
        {
          'title': title,
          'author': author,
          'location': location,
          'condition': condition,
          'genre': genre,
          'publication_date': publicationDate,
          'availability': availability,
          'notes': notes,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Libro insertado: $title');
    } catch (e) {
      print('Error al insertar libro: $e');
      throw Exception('Error al insertar libro: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getBooks() async {
    final db = await database;
    return await db.query('books');
  }

  Future<void> updateBook(int id, String title, String author, String location, String condition, String genre, String publicationDate, String availability, String notes) async {
    final db = await database;
    await db.update(
      'books',
      {
        'title': title,
        'author': author,
        'location': location,
        'condition': condition,
        'genre': genre,
        'publication_date': publicationDate,
        'availability': availability,
        'notes': notes,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteBook(int id) async {
    final db = await database;
    await db.delete(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getBooksByGenre(String genre) async {
    final db = await database;
    return await db.query(
      'books',
      where: 'genre = ?',
      whereArgs: [genre],
    );
  }
}
