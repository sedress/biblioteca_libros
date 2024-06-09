import 'package:flutter/material.dart';
import 'package:biblioteca_libros/database/db_helper.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final db = DatabaseHelper();
    final user = await db.getUser(username);

    if (user != null && user['password'] == password) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Nombre de Usuario o Contraseña Incorrecta'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inicio de Sesión',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF332612),
        iconTheme: IconThemeData(
            color: Colors.white),
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
              width: 320,
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre de Usuario',
                      labelStyle: TextStyle(
                          color: Colors.white),
                    ),
                    style: TextStyle(
                        color: Colors.white),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      labelStyle: TextStyle(
                          color: Colors.white),
                    ),
                    obscureText: true,
                    style: TextStyle(
                        color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _login,
                    child: Text('Iniciar Sesión',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF332612),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: Size(
                          double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}