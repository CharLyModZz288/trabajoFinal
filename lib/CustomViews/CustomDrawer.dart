import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {


  Function(int indice)? onItemTap;
  String imagen;

  CustomDrawer({Key? key, required this.onItemTap, required this.imagen
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  imagen,
                  width: 100,
                  height: 100,
                ),
                Text(
                  "Selecciona lo que desees",
                  style: TextStyle(color: Colors.red,
                      fontSize: 20),
                ),
              ],
            ),
          ),
          ListTile(
            selectedColor: Colors.yellow,
            selected: true,
            title: const Text('Perfil'),
            onTap: () {
              onItemTap!(0);
            },
          ),
          ListTile(
            title: const Text('Cerrar Sesion'),
            onTap: () {
              onItemTap!(1);
            },
          ),

          ListTile(
            title: const Text('Consultar Mapa'),
            onTap: () {
              onItemTap!(2);
            },
          ),

          ListTile(
            title: const Text('Busqueda Titulo'),
            onTap: () {
              onItemTap!(3);
            },
          ),
          ListTile(
            title: const Text('Ajustes'),
            onTap: () {
              onItemTap!(4);
            },
          ),
          ListTile(
            title: const Text('Youtubers'),
            onTap: () {
              onItemTap!(5);
            },
          ),
        ],
      ),
    );
  }
}
