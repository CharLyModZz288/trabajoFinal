import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HelpAndSupportView extends StatefulWidget {
  @override
  _HelpAndSupportViewState createState() => _HelpAndSupportViewState();
}

class _HelpAndSupportViewState extends State<HelpAndSupportView> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getEmail();
  }

  void _getEmail() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      String email = auth.currentUser!.email!;
      setState(() {
        _emailController.text = email;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ayuda y soporte'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '¿Cómo podemos ayudarte?',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _messageController, // Asociar el controlador del mensaje
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Mensaje',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _sendContactForm(context);
              },
              child: Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }

  void _sendContactForm(BuildContext context) {
    _messageController.clear(); // Limpiar el campo de texto del mensaje
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Mensaje enviado'),
          content: Text('¡Tu mensaje ha sido enviado con éxito!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _messageController.dispose(); // Liberar el controlador del mensaje
    super.dispose();
  }
}
