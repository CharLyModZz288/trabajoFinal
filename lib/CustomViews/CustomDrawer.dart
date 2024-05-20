import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Home/SecuritySettingsView.dart';

class CustomDrawer extends StatefulWidget {
  final Function(int indice) onItemTap;
  final String imagen;

  CustomDrawer({Key? key, required this.onItemTap, required this.imagen}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late String _currentImage;
  bool _isLocalImage = false;

  @override
  void initState() {
    super.initState();
    _currentImage = widget.imagen;
    _isLocalImage = Uri.parse(_currentImage).isScheme('file');
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _currentImage = image.path;
        _isLocalImage = true;
      });
    }
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
                child: InteractiveViewer(
                  panEnabled: false,
                  scaleEnabled: true,
                  child: _isLocalImage
                      ? Image.file(File(_currentImage))
                      : Image.network(_currentImage),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _pickImage(ImageSource.gallery);
                    },
                    child: Text(
                      'Cambiar por Galería',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _pickImage(ImageSource.camera);
                    },
                    child: Text(
                      'Cambiar por Cámara',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 1,
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
                  child: _isLocalImage
                      ? Image.file(
                    File(_currentImage),
                    width: 100,
                    height: 100,
                  )
                      : Image.network(
                    _currentImage,
                    width: 100,
                    height: 100,
                  ),
                ),
                SizedBox(width: 12),
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
          ListTile(
            leading: Image.asset(
              'Resources/perfil.jfif',
              width: 24.0,
              height: 24.0,
            ),
            title: const Text('Perfil'),
            onTap: () {
              widget.onItemTap(0);
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
              widget.onItemTap(5);
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
              widget.onItemTap(6);
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
              widget.onItemTap(7);
            },
          ),
          ListTile(
            leading: Image.asset(
              'Resources/maps.jfif',
              width: 24.0,
              height: 24.0,
            ),
            title: const Text('Convenciones'),
            onTap: () {
              widget.onItemTap(2);
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
              widget.onItemTap(3);
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
              widget.onItemTap(4);
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: const Text('Favoritos'),
            onTap: () {
              Navigator.push(
                context,
                  widget.onItemTap(8)
              );},
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
              widget.onItemTap(1);
            },
          ),
        ],
      ),
    );
  }
}
