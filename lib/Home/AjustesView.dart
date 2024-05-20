import 'package:flutter/material.dart';

import 'AboutView.dart';
import 'HelpAndSupportView.dart';
import 'LanguageView.dart';
import 'SecuritySettingsView.dart';
import 'ThemeView.dart';

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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LanguageView()),
              );},
          ),

          ListTile(
            leading: Icon(Icons.security),
            title: Text('Seguridad'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SecuritySettingsView()),
              );},
          ),
          ListTile(
            leading: Icon(Icons.brightness_6),
            title: const Text('Cambiar Tema'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ThemeView()),
              );
            },
          ),


          ListTile(
            leading: Icon(Icons.help),
            title: Text('Ayuda y soporte'),
            onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HelpAndSupportView()),
            );},
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Acerca de'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutView()),
              );
            },
          ),

        ],
      ),
    );
  }
}
