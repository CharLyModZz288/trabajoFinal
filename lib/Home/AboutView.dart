import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acerca de'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MUSEO YISMER',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Versión: 1.0.0',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Descripción de la aplicación. Esta aplicación hará que los adolescentes más jóvenes sientan curiosidad por visitar un museo, pero de manera diferente, ya que tendrá temas que interesen a la gran mayoría de la juventud.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Desarrollado por: Carlos Escrivá Segovia',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Contacto: escrivasegoviac@gmail.com',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            // Aquí agrego la imagen
            Expanded(
              child: Image.asset(
                'Resources/logoApp.png',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
