import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BookDatabaseHelper {
  static final BookDatabaseHelper _instance = BookDatabaseHelper._internal();
  static Database? _database;

  factory BookDatabaseHelper() {
    return _instance;
  }

  BookDatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'books.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE books(
            id INTEGER PRIMARY KEY,
            title TEXT,
            author TEXT,
            genre TEXT,
            condition TEXT,
            availability TEXT,
            location TEXT,
            notes TEXT,
            pdfPath TEXT
          )
        ''');
      },
    );
  }

  Future<List<Map<String, dynamic>>> getBooks() async {
    final db = await database;
    return await db.query('books');
  }

  Future<void> insertSampleBooks() async {
    final db = await database;

    // Check if there are already books in the database
    var existingBooks = await db.query('books');
    if (existingBooks.isNotEmpty) return; // Skip if there are already books

    await db.insert('books', {
      'title': 'Libro de Ejemplo 1',
      'author': 'Autor 1',
      'genre': 'Fantasía',
      'condition': 'Nuevo',
      'availability': 'Sí',
      'location': 'Sección A',
      'notes': 'Este es un libro de ejemplo.',
      'pdfPath': 'assets/pdfs/sample1.pdf',
    });

    await db.insert('books', {
      'title': 'Libro de Ejemplo 2',
      'author': 'Autor 2',
      'genre': 'Ciencia Ficción',
      'condition': 'Usado - Buen estado',
      'availability': 'Sí',
      'location': 'Sección B',
      'notes': 'Este es otro libro de ejemplo.',
      'pdfPath': 'assets/pdfs/sample2.pdf',
    });
  }
}
