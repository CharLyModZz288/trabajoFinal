import 'package:flutter/material.dart';

class CustomDrawerAdmin extends StatelessWidget {
  final Function(int indice) onItemTap;
  final String imagen;

  CustomDrawerAdmin({Key? key, required this.onItemTap, required this.imagen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 1, // Ajusta este valor para controlar el ancho
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  SizedBox(height: 10),
                  Text(
                    'Bienvenido de nuevo jefe',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                ],
              ),
            ),
          ),
          _buildCircularListTile('Resources/perfil.jfif', 'Perfil', () {
            onItemTap(0);
          }),
          _buildCircularListTile('Resources/youtube.png', 'Youtube', () {
            onItemTap(5);
          }),
          _buildCircularListTile('Resources/tik tok.png', 'TikTok', () {
            onItemTap(6);
          }),
          _buildCircularListTile('Resources/twitch.jfif', 'Twitch', () {
            onItemTap(7);
          }),
          _buildCircularListTile('Resources/ajustes.png', 'Ajustes', () {
            onItemTap(4);
          }),
          _buildCircularListTile('Resources/logout.jfif', 'Cerrar Sesión', () {
            onItemTap(1);
          }),
        ],
      ),
    );
  }

  Widget _buildCircularListTile(String imagePath, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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
    );
  }

  void _showImageWithZoom(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black54,
          child: InteractiveViewer(
            panEnabled: false,
            scaleEnabled: true,
            child: Image.network(imagen),
          ),
        );
      },
    );
  }
}
