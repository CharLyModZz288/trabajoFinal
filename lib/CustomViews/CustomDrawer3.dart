import 'package:flutter/material.dart';

class CustomDrawer3 extends StatelessWidget {
  final Function(int indice)? onItemTap;
  final String imagen;

  CustomDrawer3({Key? key, required this.onItemTap, required this.imagen}) : super(key: key);

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
                      'Bienvenido al Mundo Influencer',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      'Quieres saber mas de Marta Diaz',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      ' u otros influencers',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: Image.asset(
              'Resources/perfil.jfif',
              width: 24.0,
              height: 24.0,
            ),
            title: const Text('Perfil'),
            onTap: () {
              if (onItemTap != null) onItemTap!(0);
            },
          ),
          ListTile(
            leading: Image.asset(
              'Resources/inicio.png',
              width: 24.0,
              height: 24.0,
            ),
            title: const Text('Inicio'),
            onTap: () {
              if (onItemTap != null) onItemTap!(5);
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
              if (onItemTap != null) onItemTap!(2);
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
              if (onItemTap != null) onItemTap!(3);
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
              if (onItemTap != null) onItemTap!(4);
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
              if (onItemTap != null) onItemTap!(1);
            },
          ),
        ],
      ),
    );
  }
}
