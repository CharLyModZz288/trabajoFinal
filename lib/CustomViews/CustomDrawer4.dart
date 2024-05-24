import 'package:flutter/material.dart';

class CustomDrawer4 extends StatelessWidget {
  final Function(int indice)? onItemTap;
  final String imagen;

  CustomDrawer4({Key? key, required this.onItemTap, required this.imagen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 1, // Ajusta este valor para controlar el ancho
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _showImageWithZoom(context);
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(imagen),
                  ),
                ),
                SizedBox(height: 0),
                Text(
                  'Bienvenido al Mundo Streamer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),


              ],
            ),

          ),
          _buildCircularListTile('Resources/perfil.jfif', 'Perfil', () {
            if (onItemTap != null) {
              onItemTap!(0);
            }
          }),
          _buildCircularListTile('Resources/inicio.png', 'Inicio', () {
            if (onItemTap != null) {
              onItemTap!(5);
            }
          }),
          _buildCircularListTile('Resources/maps.jfif', 'Convenciones', () {
            if (onItemTap != null) {
              onItemTap!(2);
            }
          }),
          _buildCircularListTile('Resources/busqueda.jfif', 'Búsqueda', () {
            if (onItemTap != null) {
              onItemTap!(3);
            }
          }),
          _buildCircularListTile('Resources/ajustes.png', 'Ajustes', () {
            if (onItemTap != null) {
              onItemTap!(4);
            }
          }),
          _buildCircularListTile('Resources/logout.jfif', 'Cerrar Sesión', () {
            if (onItemTap != null) {
              onItemTap!(1);
            }
          }),
        ],
      ),
    );
  }
  Widget _buildCircularListTile(
      String imagePath, String title, VoidCallback onTap) {
    return ListTile(
      title: Center(
        child: Column(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.black,
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage(imagePath),
              ),
            ),
            SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      onTap: onTap,
    );
  }

  void _showImageWithZoom(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black54,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      _pickImage(context);
                    },
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(imagen),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _pickImage(context);
                },
                child: Text(
                  'Cambiar imagen',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    // Aquí implementa la lógica para seleccionar una nueva imagen
    // Puedes usar ImagePicker o cualquier otra solución que prefieras
  }
}
