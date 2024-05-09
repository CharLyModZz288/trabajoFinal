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
              'Descripción de la aplicación. Esta aplicación hara que lo adolencentes más jovenes le entre la curiosidad de ver un museo pero diferente,ya que va a tener gustos y los de la gran mayoria de la juventud, y proximamente tendremos su futura construccion.',
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

          ],
        ),
      ),
    );
  }
}
