import 'package:flutter/material.dart';
import 'package:biblioteca_libros/database/book_db_helper.dart';
import 'package:biblioteca_libros/screens/pdf_viewer_screen.dart';

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  List<Map<String, dynamic>> _books = [];

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    await _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    final books = await BookDatabaseHelper().getBooks();
    print('Books fetched: ${books.length}');
    setState(() {
      _books = books;
    });
  }

  Future<void> _insertSampleBooks() async {
    await BookDatabaseHelper().insertSampleBooks();
    await _fetchBooks();
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
        title: Text(
          'Lista de Libros',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF332612),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.white,
            onPressed: _insertSampleBooks,
          ),
        ],
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

          Center(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Color(0xFF6F624B).withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ListView.builder(
                itemCount: _books.length,
                itemBuilder: (context, index) {
                  final book = _books[index];
                  return Card(
                    color: Color(0xFF453823),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        book['title'],
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'Autor: ${book['author']}',
                        style: TextStyle(color: Colors.white70),
                      ),
                      onTap: () => _showBookDetails(book),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
