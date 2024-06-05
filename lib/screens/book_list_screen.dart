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
    await BookDatabaseHelper().insertSampleBooks();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    final books = await BookDatabaseHelper().getBooks();
    print('Books fetched: ${books.length}');
    setState(() {
      _books = books;
    });
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
      body: ListView.builder(
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
    );
  }
}
