import 'package:flutter/material.dart';

class CustomDrawerAdmin extends StatelessWidget {
  Function(int indice)? onItemTap;
  String imagen;

  CustomDrawerAdmin({Key? key, required this.onItemTap, required this.imagen}) : super(key: key);

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
                      'Bienvenido de nuevo jefe',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '¿Que es lo que deseas añadir,',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'modificar o eliminar esta vez?',
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
            title: const Text('Youtube'),
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
            title: const Text('TikTok'),
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

            title: const Text('Twitch'),
            onTap: () {
              onItemTap!(7);
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
