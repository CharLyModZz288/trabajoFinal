import 'package:flutter/material.dart';

class AjustesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajustes'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notificaciones'),
            onTap: () {
              // Acción al tocar la opción de notificaciones
            },
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Idioma'),
            onTap: () {
              // Acción al tocar la opción de idioma
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Cuenta'),
            onTap: () {
              // Acción al tocar la opción de cuenta
            },
          ),
          ListTile(
            leading: Icon(Icons.security),
            title: Text('Seguridad'),
            onTap: () {
              // Acción al tocar la opción de seguridad
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Ayuda y soporte'),
            onTap: () {
              // Acción al tocar la opción de ayuda y soporte
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Acerca de'),
            onTap: () {
              // Acción al tocar la opción de acerca de
            },
          ),
        ],
      ),
    );
  }
}
