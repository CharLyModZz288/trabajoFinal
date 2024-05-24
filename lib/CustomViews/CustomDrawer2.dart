import 'package:flutter/material.dart';

class CustomDrawer2 extends StatelessWidget {
  final Function(int indice)? onItemTap;
  final String imagen;

  CustomDrawer2({Key? key, required this.onItemTap, required this.imagen}) : super(key: key);

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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Imagen
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(imagen),
                ),
                SizedBox(height: 12), // Espacio entre la imagen y el texto
                // Texto debajo de la imagen
                Column(
                  children: [
                    Text(
                      'Bienvenido al Mundo Youtuber',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ],
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
}
