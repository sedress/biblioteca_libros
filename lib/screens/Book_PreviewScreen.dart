import 'package:flutter/material.dart';
import 'package:biblioteca_libros/database/db_helper.dart';

class BookPreviewScreen extends StatefulWidget {
  @override
  _BookPreviewScreenState createState() => _BookPreviewScreenState();
}

class _BookPreviewScreenState extends State<BookPreviewScreen> {
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
    final books = await DatabaseHelper().getBooks();
    setState(() {
      _books = books;
    });
  }

  void _filterBooks() async {
    final db = await DatabaseHelper().database;
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
        title: Text(
          'Vista Previa de Libros',
          style: TextStyle(color: Colors.white), // Texto blanco
        ),
        backgroundColor: Color(0xFF332612), // Marrón Más Oscuro
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Icono blanco
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          // Imagen de fondo
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenedor con lista de libros y filtros
          Column(
            children: [
              _buildFilterControls(),
              Expanded(
                child: ListView.builder(
                  itemCount: _books.length,
                  itemBuilder: (context, index) {
                    final book = _books[index];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Color(0xFF6F624B).withOpacity(0.8), // Marrón Claro con Opacidad
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: Colors.white, width: 2.0), // Contorno blanco
                      ),
                      child: ListTile(
                        title: Text(
                          book['title'],
                          style: TextStyle(color: Colors.white), // Texto blanco
                        ),
                        subtitle: Text(
                          'Autor: ${book['author']}',
                          style: TextStyle(color: Colors.white70), // Texto blanco con opacidad
                        ),
                        onTap: () => _showBookDetails(book),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterControls() {
    return ExpansionTile(
      title: Text(
        'Filtros de búsqueda',
        style: TextStyle(color: Colors.white), // Texto blanco
      ),
      backgroundColor: Color(0xFF453823), // Color de fondo del ExpansionTile
      collapsedBackgroundColor: Color(0xFF453823), // Color de fondo cuando está colapsado
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
          ['Si', 'No'],
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
              child: Text('Filtrar', style: TextStyle(color: Colors.white)), // Texto blanco
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF332612), // Marrón Más Oscuro
              ),
            ),
            ElevatedButton(
              onPressed: _clearFilters,
              child: Text('Limpiar Filtros', style: TextStyle(color: Colors.white)), // Texto blanco
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF332612), // Marrón Más Oscuro
              ),
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
        hint: Text(hint, style: TextStyle(color: Colors.white)), // Texto blanco
        value: value,
        onChanged: onChanged,
        isExpanded: true,
        dropdownColor: Color(0xFF453823), // Color de fondo del dropdown
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: TextStyle(color: Colors.white)), // Texto blanco
          );
        }).toList(),
      ),
    );
  }
}
