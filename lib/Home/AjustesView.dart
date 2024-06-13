import 'package:flutter/material.dart';

import 'AboutView.dart';
import 'HelpAndSupportView.dart';
import 'SecuritySettingsView.dart';

class AjustesView extends StatefulWidget {
  @override
  _AjustesViewState createState() => _AjustesViewState();
}

class _AjustesViewState extends State<AjustesView> {
  bool _notificationsEnabled = false;

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
              _showConfirmationDialog(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.security),
            title: Text('Seguridad'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SecuritySettingsView()),
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
              );
            },
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

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_notificationsEnabled ? 'Desactivar Notificaciones' : 'Activar Notificaciones'),
          content: Text(_notificationsEnabled
              ? '¿Deseas desactivar las notificaciones?'
              : '¿Deseas activar las notificaciones?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo
              },
            ),
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                setState(() {
                  _notificationsEnabled = !_notificationsEnabled; // Cambia el estado de las notificaciones
                });
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo
              },
            ),
          ],
        );
      },
    );
  }
}
