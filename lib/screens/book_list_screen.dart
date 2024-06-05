import 'package:flutter/material.dart';
import 'package:biblioteca_libros/database/book_db_helper.dart';
import 'package:biblioteca_libros/screens/pdf_viewer_screen.dart';

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  List<Map<String, dynamic>> _books = [];
  String? _selectedGenre;
  String? _selectedCondition;
  String? _selectedAvailability;
  String? _selectedSection;

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    final books = await BookDatabaseHelper().getBooks();
    setState(() {
      _books = books;
    });
  }

  void _filterBooks() async {
    final db = await BookDatabaseHelper().database;
    String whereClause = "";
    List<dynamic> whereArgs = [];

    if (_selectedGenre != null) {
      whereClause += 'genre = ?';
      whereArgs.add(_selectedGenre);
    }

    if (_selectedCondition != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'condition = ?';
      whereArgs.add(_selectedCondition);
    }

    if (_selectedAvailability != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'availability = ?';
      whereArgs.add(_selectedAvailability);
    }

    if (_selectedSection != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'location = ?';
      whereArgs.add(_selectedSection);
    }

    final books = whereClause.isEmpty
        ? await db.query('books')
        : await db.query('books', where: whereClause, whereArgs: whereArgs);

    setState(() {
      _books = books;
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedGenre = null;
      _selectedCondition = null;
      _selectedAvailability = null;
      _selectedSection = null;
    });
    _fetchBooks();
  }

  void _showBookDetails(Map<String, dynamic> book) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(book['title']),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Autor: ${book['author']}'),
                Text('Género: ${book['genre']}'),
                Text('Estado: ${book['condition']}'),
                Text('Disponibilidad: ${book['availability']}'),
                Text('Sección: ${book['location']}'),
                Text('Descripción: ${book['notes']}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Leer PDF'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PdfViewerScreen(pdfAssetPath: book['pdfPath']),
                  ),
                );
              },
            ),
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Libros'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          _buildFilterControls(),
          Expanded(
            child: ListView.builder(
              itemCount: _books.length,
              itemBuilder: (context, index) {
                final book = _books[index];
                return ListTile(
                  title: Text(book['title']),
                  subtitle: Text('Autor: ${book['author']}'),
                  onTap: () => _showBookDetails(book),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterControls() {
    return ExpansionTile(
      title: Text('Filtros de búsqueda'),
      children: [
        _buildDropdown(
          'Seleccione Género',
          _selectedGenre,
              (value) {
            setState(() {
              _selectedGenre = value;
            });
          },
          [
            'Misterio', 'Romance', 'Ciencia Ficción', 'Fantasía',
            'Suspenso', 'Terror', 'Biografía', 'Historia', 'Ciencia',
            'Arte', 'Cocina', 'Viajes', 'Autoayuda',
            'Literatura Infantil y Juvenil', 'Cómics y Novelas Gráficas',
            'Libros de Idiomas',
          ],
        ),
        _buildDropdown(
          'Seleccione Estado',
          _selectedCondition,
              (value) {
            setState(() {
              _selectedCondition = value;
            });
          },
          [
            'Nuevo', 'Usado - Buen estado', 'Usado - Aceptable', 'Usado - Dañado'
          ],
        ),
        _buildDropdown(
          'Seleccione Disponibilidad',
          _selectedAvailability,
              (value) {
            setState(() {
              _selectedAvailability = value;
            });
          },
          ['Sí', 'No'],
        ),
        _buildDropdown(
          'Seleccione Sección',
          _selectedSection,
              (value) {
            setState(() {
              _selectedSection = value;
            });
          },
          ['Sección A', 'Sección B', 'Sección C', 'Sección D', 'Sección E'],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _filterBooks,
              child: Text('Filtrar'),
            ),
            ElevatedButton(
              onPressed: _clearFilters,
              child: Text('Limpiar Filtros'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdown(
      String hint,
      String? value,
      ValueChanged<String?> onChanged,
      List<String> items,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: DropdownButton<String>(
        hint: Text(hint),
        value: value,
        onChanged: onChanged,
        isExpanded: true,
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
