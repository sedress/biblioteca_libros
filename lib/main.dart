import 'package:flutter/material.dart';
import 'package:biblioteca_libros/screens/login_screen.dart';
import 'package:biblioteca_libros/screens/register_screen.dart';
import 'package:biblioteca_libros/screens/home_screen.dart';
import 'package:biblioteca_libros/screens/welcome_screen.dart';
import 'package:biblioteca_libros/screens/Book_PreviewScreen.dart';
import 'package:biblioteca_libros/database/book_db_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BookDatabaseHelper().insertSampleBooks(); // Insertar libros de ejemplo
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => WelcomeScreen(),
        '/register': (context) => RegisterScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/bookPreview': (context) => BookPreviewScreen(),
      },
    );
  }
}
