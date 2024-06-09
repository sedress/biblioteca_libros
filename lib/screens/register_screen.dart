import 'package:flutter/material.dart';
import 'package:biblioteca_libros/database/db_helper.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text;
      final password = _passwordController.text;

      final db = DatabaseHelper();
      bool usernameTaken = await db.isUsernameTaken(username);

      if (usernameTaken) {
        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text('Error'),
                content: Text('El nombre de usuario ya está registrado'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Aceptar'),
                  ),
                ],
              ),
        );
      } else {
        await db.insertUser(username, password);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Usuario registrado correctamente'),
            duration: Duration(seconds: 1),
          ),
        );
        await Future.delayed(Duration(seconds: 2));

        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registro de Usuarios',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF332612),
        iconTheme: IconThemeData(
            color: Colors.white),
      ),
      body: Stack(
        children: <Widget>[
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
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Nombre de Usuario',
                        labelStyle: TextStyle(
                            color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa tu nombre de usuario';
                        }
                        if (value.contains(' ')) {
                          return 'El nombre de usuario no puede contener espacios';
                        }
                        if (value.length < 4) {
                          return 'El nombre de usuario debe tener al menos 4 caracteres';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        labelStyle: TextStyle(
                            color: Colors.white),
                      ),
                      obscureText: true,
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa tu contraseña';
                        }
                        if (value.length < 6) {
                          return 'La contraseña debe tener al menos 6 caracteres';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirmar Contraseña',
                        labelStyle: TextStyle(
                            color: Colors.white),
                      ),
                      obscureText: true,
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirma tu contraseña';
                        }
                        if (value != _passwordController.text) {
                          return 'Las contraseñas no coinciden';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _register,
                      child: Text(
                          'Registrarse', style: TextStyle(color: Colors.white)),
                      // Texto blanco
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
          ),
        ],
      ),
    );
  }
}