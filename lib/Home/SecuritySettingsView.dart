import 'package:flutter/material.dart';

class SecuritySettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seguridad'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Cambio de contraseña'),
            onTap: () {
              // Acción para cambiar la contraseña
            },
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Verificación en dos pasos'),
            onTap: () {
              // Acción para gestionar la verificación en dos pasos
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Historial de inicio de sesión'),
            onTap: () {
              // Acción para mostrar el historial de inicio de sesión
            },
          ),
          ListTile(
            leading: Icon(Icons.devices),
            title: Text('Gestión de dispositivos'),
            onTap: () {
              // Acción para gestionar los dispositivos asociados a la cuenta
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Cerrar sesión en todos los dispositivos'),
            onTap: () {
              // Acción para cerrar sesión en todos los dispositivos
            },
          ),
        ],
      ),
    );
  }
}