import 'package:flutter/material.dart';

class CustomDrawer2 extends StatelessWidget {


  Function(int indice)? onItemTap;
  String imagen;

  CustomDrawer2({Key? key, required this.onItemTap, required this.imagen
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
                //Text(
                  //"Selecciona lo que desees",
                  //style: TextStyle(color: Colors.red,
                    //  fontSize: 20),
                //),
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
              onItemTap!(0);
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
              onItemTap!(5);
            },
          ),

          ListTile(
            leading: Image.asset(
              'Resources/maps.jfif',
              width: 24.0,
              height: 24.0,
            ),
            title: const Text('Ver Ubicacion del Museo'),
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
            title: const Text('Busqueda de Publicación por Titulo'),
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
            title: const Text('Cerrar Sesion'),
            onTap: () {
              onItemTap!(1);
            },
          ),
        ],
      ),
    );
  }
}
