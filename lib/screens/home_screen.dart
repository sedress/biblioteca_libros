import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Asegúrate de que esta importación esté presente y correctamente escrita
import 'package:biblioteca_libros/database/db_helper.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Map<String, dynamic>>> booksFuture;
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _refreshBooks();
  }

  void _refreshBooks() {
    setState(() {
      booksFuture = dbHelper.getBooks();
    });
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _showAddBookDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final titleController = TextEditingController();
        final authorController = TextEditingController();
        final locationController = TextEditingController();
        final conditionController = TextEditingController();
        final genreController = TextEditingController();
        final publicationDateController = TextEditingController();
        final availabilityController = TextEditingController();
        final notesController = TextEditingController();

        String? location;
        String? condition;
        String? genre;
        String? availability;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Agregar Libro'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: 'Título'),
                    ),
                    TextField(
                      controller: authorController,
                      decoration: InputDecoration(labelText: 'Autor'),
                    ),
                    InputDecorator(
                      decoration: InputDecoration(labelText: 'Ubicación'),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: location,
                          isExpanded: true,
                          hint: Text('Seleccione la ubicación'),
                          onChanged: (String? newValue) {
                            setState(() {
                              location = newValue!;
                              locationController.text = location!;
                            });
                          },
                          items: <String>[
                            'Sección A',
                            'Sección B',
                            'Sección C',
                            'Sección D',
                            'Sección E'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    InputDecorator(
                      decoration: InputDecoration(labelText: 'Estado'),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: condition,
                          isExpanded: true,
                          hint: Text('Seleccione el estado'),
                          onChanged: (String? newValue) {
                            setState(() {
                              condition = newValue!;
                              conditionController.text = condition!;
                            });
                          },
                          items: <String>[
                            'Nuevo',
                            'Usado - Buen estado',
                            'Usado - Aceptable',
                            'Usado - Dañado'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    InputDecorator(
                      decoration: InputDecoration(labelText: 'Género'),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: genre,
                          isExpanded: true,
                          hint: Text('Seleccione el género'),
                          onChanged: (String? newValue) {
                            setState(() {
                              genre = newValue!;
                              genreController.text = genre!;
                            });
                          },
                          items: <String>[
                            'Misterio',
                            'Romance',
                            'Ciencia Ficción',
                            'Fantasía',
                            'Suspenso',
                            'Terror',
                            'Biografía',
                            'Historia',
                            'Ciencia',
                            'Arte',
                            'Cocina',
                            'Viajes',
                            'Autoayuda',
                            'Literatura Infantil y Juvenil',
                            'Cómics y Novelas Gráficas',
                            'Libros de Idiomas'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    TextField(
                      controller: publicationDateController,
                      onTap: () => _selectDate(context, publicationDateController),
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Fecha de Publicación',
                        hintText: 'Seleccione la fecha',
                      ),
                    ),
                    InputDecorator(
                      decoration: InputDecoration(labelText: 'Disponibilidad'),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: availability,
                          isExpanded: true,
                          hint: Text('Seleccione la disponibilidad'),
                          onChanged: (String? newValue) {
                            setState(() {
                              availability = newValue!;
                              availabilityController.text = availability!;
                            });
                          },
                          items: <String>['Sí', 'No'].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    TextField(
                      controller: notesController,
                      decoration: InputDecoration(labelText: 'Notas'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (titleController.text.isEmpty ||
                        authorController.text.isEmpty ||
                        locationController.text.isEmpty ||
                        conditionController.text.isEmpty ||
                        genreController.text.isEmpty ||
                        publicationDateController.text.isEmpty ||
                        availabilityController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Por favor, complete todos los campos.')),
                      );
                      return;
                    }
                    dbHelper.insertBook(
                      titleController.text,
                      authorController.text,
                      locationController.text,
                      conditionController.text,
                      genreController.text,
                      publicationDateController.text,
                      availabilityController.text,
                      notesController.text,
                    ).then((_) {
                      _refreshBooks();
                      Navigator.of(context).pop();
                    });
                  },
                  child: Text('Guardar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditBookDialog(int id, String currentTitle, String currentAuthor, String currentLocation, String currentCondition, String currentGenre, String currentPublicationDate, String currentAvailability, String currentNotes) {
    showDialog(
      context: context,
      builder: (context) {
        final titleController = TextEditingController(text: currentTitle);
        final authorController = TextEditingController(text: currentAuthor);
        final locationController = TextEditingController(text: currentLocation);
        final conditionController = TextEditingController(text: currentCondition);
        final genreController = TextEditingController(text: currentGenre);
        final publicationDateController = TextEditingController(text: currentPublicationDate);
        final availabilityController = TextEditingController(text: currentAvailability);
        final notesController = TextEditingController(text: currentNotes);

        String? location = currentLocation;
        String? condition = currentCondition;
        String? genre = currentGenre;
        String? availability = currentAvailability;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Editar Libro'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: 'Título'),
                    ),
                    TextField(
                      controller: authorController,
                      decoration: InputDecoration(labelText: 'Autor'),
                    ),
                    InputDecorator(
                      decoration: InputDecoration(labelText: 'Ubicación'),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: location,
                          isExpanded: true,
                          hint: Text('Seleccione la ubicación'),
                          onChanged: (String? newValue) {
                            setState(() {
                              location = newValue!;
                              locationController.text = location!;
                            });
                          },
                          items: <String>[
                            'Sección A',
                            'Sección B',
                            'Sección C',
                            'Sección D',
                            'Sección E'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    InputDecorator(
                      decoration: InputDecoration(labelText: 'Estado'),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: condition,
                          isExpanded: true,
                          hint: Text('Seleccione el estado'),
                          onChanged: (String? newValue) {
                            setState(() {
                              condition = newValue!;
                              conditionController.text = condition!;
                            });
                          },
                          items: <String>[
                            'Nuevo',
                            'Usado - Buen estado',
                            'Usado - Aceptable',
                            'Usado - Dañado'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    InputDecorator(
                      decoration: InputDecoration(labelText: 'Género'),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: genre,
                          isExpanded: true,
                          hint: Text('Seleccione el género'),
                          onChanged: (String? newValue) {
                            setState(() {
                              genre = newValue!;
                              genreController.text = genre!;
                            });
                          },
                          items: <String>[
                            'Misterio',
                            'Romance',
                            'Ciencia Ficción',
                            'Fantasía',
                            'Suspenso',
                            'Terror',
                            'Biografía',
                            'Historia',
                            'Ciencia',
                            'Arte',
                            'Cocina',
                            'Viajes',
                            'Autoayuda',
                            'Literatura Infantil y Juvenil',
                            'Cómics y Novelas Gráficas',
                            'Libros de Idiomas'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    TextField(
                      controller: publicationDateController,
                      onTap: () => _selectDate(context, publicationDateController),
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Fecha de Publicación',
                        hintText: 'Seleccione la fecha',
                      ),
                    ),
                    InputDecorator(
                      decoration: InputDecoration(labelText: 'Disponibilidad'),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: availability,
                          isExpanded: true,
                          hint: Text('Seleccione la disponibilidad'),
                          onChanged: (String? newValue) {
                            setState(() {
                              availability = newValue!;
                              availabilityController.text = availability!;
                            });
                          },
                          items: <String>['Sí', 'No'].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    TextField(
                      controller: notesController,
                      decoration: InputDecoration(labelText: 'Notas'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (titleController.text.isEmpty ||
                        authorController.text.isEmpty ||
                        locationController.text.isEmpty ||
                        conditionController.text.isEmpty ||
                        genreController.text.isEmpty ||
                        publicationDateController.text.isEmpty ||
                        availabilityController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Por favor, complete todos los campos.')),
                      );
                      return;
                    }
                    dbHelper.updateBook(
                      id,
                      titleController.text,
                      authorController.text,
                      locationController.text,
                      conditionController.text,
                      genreController.text,
                      publicationDateController.text,
                      availabilityController.text,
                      notesController.text,
                    ).then((_) {
                      _refreshBooks();
                      Navigator.of(context).pop();
                    });
                  },
                  child: Text('Guardar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showBookDetails(Map<String, dynamic> book) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(book['title']),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Autor: ${book['author']}'),
                Text('Ubicación: ${book['location']}'),
                Text('Estado: ${book['condition']}'),
                Text('Género: ${book['genre']}'),
                Text('Fecha de Publicación: ${book['publication_date']}'),
                Text('Disponibilidad: ${book['availability']}'),
                Text('Notas: ${book['notes']}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
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
        title: Text('Biblioteca'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: booksFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.isEmpty) {
            return Center(child: Text('No hay libros en la biblioteca.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final book = snapshot.data![index];
              return ListTile(
                title: Text(book['title']),
                subtitle: Text('${book['author']} - ${book['availability']}'),
                onTap: () => _showBookDetails(book),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _showEditBookDialog(
                          book['id'],
                          book['title'],
                          book['author'],
                          book['location'],
                          book['condition'],
                          book['genre'],
                          book['publication_date'],
                          book['availability'],
                          book['notes'],
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        dbHelper.deleteBook(book['id']).then((_) {
                          _refreshBooks();
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddBookDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
