import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:biblioteca_libros/database/db_helper.dart';
import 'package:biblioteca_libros/screens/welcome_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Map<String, dynamic>>> booksFuture;
  final DatabaseHelper dbHelper = DatabaseHelper();

  // Método para cerrar sesión
  void _logout() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => WelcomeScreen()),
    );
  }

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

  Future<void> _selectDate(BuildContext context,
      TextEditingController controller) async {
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
                      onTap: () =>
                          _selectDate(context, publicationDateController),
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
                          items: <String>['Sí', 'No'].map<
                              DropdownMenuItem<String>>((String value) {
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
                        SnackBar(content: Text(
                            'Por favor, complete todos los campos.')),
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

  void _showEditBookDialog(int id, String currentTitle, String currentAuthor,
      String currentLocation, String currentCondition, String currentGenre,
      String currentPublicationDate, String currentAvailability,
      String currentNotes) {
    showDialog(
      context: context,
      builder: (context) {
        final titleController = TextEditingController(text: currentTitle);
        final authorController = TextEditingController(text: currentAuthor);
        final locationController = TextEditingController(text: currentLocation);
        final conditionController = TextEditingController(
            text: currentCondition);
        final genreController = TextEditingController(text: currentGenre);
        final publicationDateController = TextEditingController(
            text: currentPublicationDate);
        final availabilityController = TextEditingController(
            text: currentAvailability);
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
                      onTap: () =>
                          _selectDate(context, publicationDateController),
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
                          items: <String>['Sí', 'No'].map<
                              DropdownMenuItem<String>>((String value) {
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
                        SnackBar(content: Text(
                            'Por favor, complete todos los campos.')),
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

  void _insertMultipleBooks() async {
    List<Map<String, String>> books = [
      {
        'title': 'Cien años de soledad',
        'author': 'Gabriel García Márquez',
        'location': 'Ficción Latinoamericana',
        'condition': 'Nuevo',
        'genre': 'Realismo Mágico',
        'publication_date': '1967-05-30',
        'availability': 'Sí',
        'notes': 'Una obra maestra de la literatura universal.',
      },
      {
        'title': 'Don Quijote de la Mancha',
        'author': 'Miguel de Cervantes',
        'location': 'Clásicos Españoles',
        'condition': 'Usado - Buen estado',
        'genre': 'Novela de Aventuras',
        'publication_date': '1605-01-16',
        'availability': 'No',
        'notes': 'Considerada la mejor obra de la literatura española.',
      },
      {
        'title': 'Rayuela',
        'author': 'Julio Cortázar',
        'location': 'Ficción Latinoamericana',
        'condition': 'Nuevo',
        'genre': 'Novela Experimental',
        'publication_date': '1963-06-28',
        'availability': 'Sí',
        'notes': 'Una novela innovadora que rompe con la estructura tradicional.',
      },
      {
        'title': 'La sombra del viento',
        'author': 'Carlos Ruiz Zafón',
        'location': 'Novela Contemporánea',
        'condition': 'Nuevo',
        'genre': 'Misterio',
        'publication_date': '2001-04-01',
        'availability': 'Sí',
        'notes': 'El primero de la saga del Cementerio de los Libros Olvidados.',
      },
      {
        'title': 'La casa de los espíritus',
        'author': 'Isabel Allende',
        'location': 'Ficción Latinoamericana',
        'condition': 'Usado - Buen estado',
        'genre': 'Realismo Mágico',
        'publication_date': '1982-01-01',
        'availability': 'Sí',
        'notes': 'Una historia familiar llena de magia y tragedia.',
      },
      {
        'title': 'Pedro Páramo',
        'author': 'Juan Rulfo',
        'location': 'Clásicos Latinoamericanos',
        'condition': 'Nuevo',
        'genre': 'Realismo Mágico',
        'publication_date': '1955-01-01',
        'availability': 'Sí',
        'notes': 'Una obra clave en la literatura mexicana del siglo XX.',
      },
      {
        'title': 'Crónica de una muerte anunciada',
        'author': 'Gabriel García Márquez',
        'location': 'Ficción Latinoamericana',
        'condition': 'Usado - Buen estado',
        'genre': 'Realismo Mágico',
        'publication_date': '1981-01-01',
        'availability': 'Sí',
        'notes': 'Una novela corta que mezcla suspense y tragedia.',
      },
      {
        'title': 'La ciudad y los perros',
        'author': 'Mario Vargas Llosa',
        'location': 'Ficción Latinoamericana',
        'condition': 'Nuevo',
        'genre': 'Novela',
        'publication_date': '1962-01-01',
        'availability': 'No',
        'notes': 'Una mirada crítica a la vida en un colegio militar en Perú.',
      },
      {
        'title': 'Los detectives salvajes',
        'author': 'Roberto Bolaño',
        'location': 'Ficción Latinoamericana',
        'condition': 'Nuevo',
        'genre': 'Novela',
        'publication_date': '1998-01-01',
        'availability': 'Sí',
        'notes': 'Una obra que explora la contracultura y la bohemia en México.',
      },
      {
        'title': 'Aura',
        'author': 'Carlos Fuentes',
        'location': 'Clásicos Latinoamericanos',
        'condition': 'Nuevo',
        'genre': 'Novela Gótica',
        'publication_date': '1962-01-01',
        'availability': 'Sí',
        'notes': 'Una historia misteriosa y seductora.',
      },
      {
        'title': 'El amor en los tiempos del cólera',
        'author': 'Gabriel García Márquez',
        'location': 'Ficción Latinoamericana',
        'condition': 'Nuevo',
        'genre': 'Romance',
        'publication_date': '1985-01-01',
        'availability': 'Sí',
        'notes': 'Una historia de amor inolvidable ambientada en el Caribe colombiano.',
      },
      {
        'title': 'La guerra del fin del mundo',
        'author': 'Mario Vargas Llosa',
        'location': 'Ficción Latinoamericana',
        'condition': 'Usado - Buen estado',
        'genre': 'Histórica',
        'publication_date': '1981-01-01',
        'availability': 'Sí',
        'notes': 'Una novela épica basada en hechos históricos ocurridos en Brasil.',
      },
      {
        'title': 'Los miserables',
        'author': 'Victor Hugo',
        'location': 'Clásicos Europeos',
        'condition': 'Nuevo',
        'genre': 'Novela',
        'publication_date': '1862-01-01',
        'availability': 'Sí',
        'notes': 'Una historia de redención, amor y justicia social ambientada en la Francia del siglo XIX.',
      },
      {
        'title': 'Cien años de perdón',
        'author': 'Jorge Zepeda Patterson',
        'location': 'Novela Contemporánea',
        'condition': 'Nuevo',
        'genre': 'Suspense',
        'publication_date': '2016-01-01',
        'availability': 'Sí',
        'notes': 'Una novela que mezcla intriga, política y corrupción en América Latina.',
      },
      {
        'title': 'El túnel',
        'author': 'Ernesto Sabato',
        'location': 'Clásicos Latinoamericanos',
        'condition': 'Nuevo',
        'genre': 'Existencialista',
        'publication_date': '1948-01-01',
        'availability': 'Sí',
        'notes': 'Una novela que explora la mente humana y la obsesión.',
      },
      {
        'title': 'Pantaleón y las visitadoras',
        'author': 'Mario Vargas Llosa',
        'location': 'Ficción Latinoamericana',
        'condition': 'Usado - Buen estado',
        'genre': 'Humor',
        'publication_date': '1973-01-01',
        'availability': 'Sí',
        'notes': 'Una sátira sobre la vida militar y la burocracia en Perú.',
      },
      {
        'title': 'El laberinto de los espíritus',
        'author': 'Carlos Ruiz Zafón',
        'location': 'Novela Contemporánea',
        'condition': 'Nuevo',
        'genre': 'Misterio',
        'publication_date': '2016-01-01',
        'availability': 'Sí',
        'notes': 'El último libro de la saga del Cementerio de los Libros Olvidados.',
      },
      {
        'title': 'La casa de Bernarda Alba',
        'author': 'Federico García Lorca',
        'location': 'Teatro Español',
        'condition': 'Nuevo',
        'genre': 'Tragedia',
        'publication_date': '1945-01-01',
        'availability': 'Sí',
        'notes': 'Una obra de teatro que explora la represión y la libertad femenina.',
      },
      {
        'title': 'El beso de la mujer araña',
        'author': 'Manuel Puig',
        'location': 'Ficción Latinoamericana',
        'condition': 'Nuevo',
        'genre': 'Drama',
        'publication_date': '1976-01-01',
        'availability': 'Sí',
        'notes': 'Una novela epistolar que aborda temas como la sexualidad y la represión política.',
      },
      {
        'title': '2666',
        'author': 'Roberto Bolaño',
        'location': 'Ficción Latinoamericana',
        'condition': 'Nuevo',
        'genre': 'Novela',
        'publication_date': '2004-01-01',
        'availability': 'Sí',
        'notes': 'Una novela monumental que explora el crimen y la búsqueda de la verdad.',
      },
      // Agrega más libros si es necesario
    ];
    for (var book in books) {
      try {
        await dbHelper.insertBook(
          book['title']!,
          book['author']!,
          book['location']!,
          book['condition']!,
          book['genre']!,
          book['publication_date']!,
          book['availability']!,
          book['notes']!,
        );
        print('Libro agregado: ${book['title']}');
      } catch (e) {
        print('Error al agregar el libro "${book['title']}": $e');
      }
    }

    _refreshBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Esto elimina el botón de retroceso
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _showAddBookDialog,
            child: Icon(Icons.add),
            tooltip: 'Agregar Libro',
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _insertMultipleBooks,
            child: Icon(Icons.library_add),
            tooltip: 'Agregar Múltiples Libros',
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _logout,
            child: Icon(Icons.exit_to_app),
            tooltip: 'Cerrar Sesión',
          ),
        ],
      ),
    );
  }
}