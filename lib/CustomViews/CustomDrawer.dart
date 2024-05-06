import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  Function(int indice)? onItemTap;
  String imagen;

  CustomDrawer({Key? key, required this.onItemTap, required this.imagen}) : super(key: key);

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
                // Utiliza GestureDetector alrededor de la imagen
                GestureDetector(
                  onTap: () {
                    _showImageWithZoom(context);
                  },
                  child: Image.network(
                    imagen,
                    width: 100,
                    height: 100,
                  ),
                ),
                // Espaciado entre la imagen y el texto
                SizedBox(width: 12),
                // Texto al lado de la imagen
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Bienvenido al Museo Yismer',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Descubre lo último sobre tus streamers',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'youtubers e influencers favoritos',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
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

  void _showImageWithZoom(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black54, // Opcional: haz el fondo transparente
          child: InteractiveViewer(
            // Habilita el zoom y la panorámica
            panEnabled: false, // Desactiva la panorámica si quieres centrar la imagen
            scaleEnabled: true, // Habilita el zoom
            child: Image.network(
              imagen, // Reemplaza esto con la ruta de la imagen que deseas mostrar con zoom
            ),
          ),
        );
      },
    );
  }
}
