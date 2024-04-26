import 'package:flutter/material.dart';

class CustomDrawerAdmin extends StatelessWidget {
  Function(int indice)? onItemTap;
  String imagen;

  CustomDrawerAdmin({Key? key, required this.onItemTap, required this.imagen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.6, // Ajusta este valor para controlar el ancho
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Imagen
                Image.network(
                  imagen,
                  width: 100,
                  height: 100,
                ),
                // Espaciado entre la imagen y el texto
                SizedBox(width: 12),
                // Texto al lado de la imagen
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Bienvenido de nuevo jefe',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '¿Que es lo que deseas añadir/modificar esta vez?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // ListTile de elementos
          ListTile(
            leading: Image.asset(
              'Resources/perfil.jfif',
              width: 24.0,
              height: 24.0,
            ),
            title: const Text('Perfil'),
            onTap: () {
              onItemTap!(0);
            },
          ),
          ListTile(
            leading: Image.asset(
              'Resources/youtube.png',
              width: 24.0,
              height: 24.0,
            ),
            title: const Text('Youtubers'),
            onTap: () {
              onItemTap!(5);
            },
          ),
          ListTile(
            leading: Image.asset(
              'Resources/tik tok.png',
              width: 24.0,
              height: 24.0,
            ),
            title: const Text('Influencers'),
            onTap: () {
              onItemTap!(6);
            },
          ),
          ListTile(
            leading: Image.asset(
              'Resources/twitch.jfif',
              width: 24.0,
              height: 24.0,
            ),
            title: const Text('Streamers'),
            onTap: () {
              onItemTap!(7);
            },
          ),
          ListTile(
            leading: Image.asset(
              'Resources/maps.jfif',
              width: 24.0,
              height: 24.0,
            ),
            title: const Text('Ver Ubicación del Museo'),
            onTap: () {
              onItemTap!(2);
            },
          ),
          ListTile(
            leading: Image.asset(
              'Resources/busqueda.jfif',
              width: 24.0,
              height: 24.0,
            ),
            title: const Text('Búsqueda de Publicación por Título'),
            onTap: () {
              onItemTap!(3);
            },
          ),
          ListTile(
            leading: Image.asset(
              'Resources/ajustes.png',
              width: 24.0,
              height: 24.0,
            ),
            title: const Text('Ajustes'),
            onTap: () {
              onItemTap!(4);
            },
          ),
          ListTile(
            leading: Image.asset(
              'Resources/logout.jfif',
              width: 24.0,
              height: 24.0,
            ),
            selectedColor: Colors.red,
            selected: true,
            title: const Text('Cerrar Sesión'),
            onTap: () {
              onItemTap!(1);
            },
          ),
        ],
      ),
    );
  }
}
