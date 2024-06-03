import 'package:flutter/material.dart';
import 'package:biblioteca_libros/database/db_helper.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  late Future<List<Map<String, dynamic>>> booksFuture;

  @override
  void initState() {
    super.initState();
    booksFuture = dbHelper.getBooks();
  }

  void _refreshBooks() {
    setState(() {
      booksFuture = dbHelper.getBooks();
    });
  }

  void _showAddBookDialog() {
    String title = '';
    String author = '';
    String genre = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Agregar Libro'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => title = value,
                decoration: InputDecoration(labelText: 'Título'),
              ),
              TextField(
                onChanged: (value) => author = value,
                decoration: InputDecoration(labelText: 'Autor'),
              ),
              TextField(
                onChanged: (value) => genre = value,
                decoration: InputDecoration(labelText: 'Género'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                dbHelper.insertBook(title, author, genre).then((_) {
                  _refreshBooks();
                  Navigator.of(context).pop();
                });
              },
              child: Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  void _showEditBookDialog(int id, String currentTitle, String currentAuthor, String currentGenre) {
    String title = currentTitle;
    String author = currentAuthor;
    String genre = currentGenre;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Libro'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => title = value,
                decoration: InputDecoration(labelText: 'Título', hintText: currentTitle),
              ),
              TextField(
                onChanged: (value) => author = value,
                decoration: InputDecoration(labelText: 'Autor', hintText: currentAuthor),
              ),
              TextField(
                onChanged: (value) => genre = value,
                decoration: InputDecoration(labelText: 'Género', hintText: currentGenre),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                dbHelper.updateBook(id, title, author, genre).then((_) {
                  _refreshBooks();
                  Navigator.of(context).pop();
                });
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _deleteBook(int id) {
    dbHelper.deleteBook(id).then((_) {
      _refreshBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Biblioteca'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddBookDialog,
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: booksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay libros.'));
          } else {
            final books = snapshot.data!;
            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return ListTile(
                  title: Text(book['title']),
                  subtitle: Text('${book['author']} - ${book['genre']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showEditBookDialog(
                          book['id'],
                          book['title'],
                          book['author'],
                          book['genre'],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteBook(book['id']),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
