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

    await _deleteDatabase();

    _database = await _initDatabase();
    return _database!;
  }

  Future<void> _deleteDatabase() async {
    String path = join(await getDatabasesPath(), 'books.db');
    if (await databaseExists(path)) {
      await deleteDatabase(path);
      print('Database deleted');
    }
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
    final List<Map<String, dynamic>> books = await db.query('books');
    print('Books retrieved from database: $books');
    return books;
  }

  Future<void> insertSampleBooks() async {
    final db = await database;

    await db.insert('books', {
      'title': 'Yumemiru Volumen 1',
      'author': 'Okemaru',
      'genre': 'Novela Ligera',
      'condition': 'Nuevo',
      'availability': 'Sí',
      'location': 'Sección C',
      'notes': 'Primero de la serie Yumemiru.',
      'pdfPath': 'assets/pdfs/yumemiruvolumen1.pdf',
    });

    await db.insert('books', {
      'title': 'Yumemiru Volumen 2',
      'author': 'Okemaru',
      'genre': 'Novela Ligera',
      'condition': 'Nuevo',
      'availability': 'Sí',
      'location': 'Sección C',
      'notes': 'Segundo de la serie Yumemiru.',
      'pdfPath': 'assets/pdfs/yumemiruvolumen2.pdf',
    });

    await db.insert('books', {
      'title': 'Yumemiru Volumen 3',
      'author': 'Okemaru',
      'genre': 'Novela Ligera',
      'condition': 'Nuevo',
      'availability': 'Sí',
      'location': 'Sección C',
      'notes': 'Tercero de la serie Yumemiru.',
      'pdfPath': 'assets/pdfs/yumemiruvolumen3.pdf',
    });

    await db.insert('books', {
      'title': 'Yumemiru Volumen 4',
      'author': 'Okemaru',
      'genre': 'Novela Ligera',
      'condition': 'Nuevo',
      'availability': 'Sí',
      'location': 'Sección C',
      'notes': 'Cuarto de la serie Yumemiru.',
      'pdfPath': 'assets/pdfs/yumemiruvolumen4.pdf',
    });

    await db.insert('books', {
      'title': 'Yumemiru Volumen 5',
      'author': 'Okemaru',
      'genre': 'Novela Ligera',
      'condition': 'Nuevo',
      'availability': 'Sí',
      'location': 'Sección C',
      'notes': 'Quinto de la serie Yumemiru.',
      'pdfPath': 'assets/pdfs/yumemiruvolumen5.pdf',
    });

    print('Libros insertados dentro de la base de datos');
  }
}
