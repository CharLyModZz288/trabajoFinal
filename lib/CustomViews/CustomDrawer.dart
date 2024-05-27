import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class CustomDrawer extends StatefulWidget {
  final Function(int indice) onItemTap;
  final String imagen;

  CustomDrawer({Key? key, required this.onItemTap, required this.imagen})
      : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late String _currentImage;
  bool _isLocalImage = false;
  String? _documentId;

  @override
  void initState() {
    super.initState();
    _currentImage = widget.imagen;
    _isLocalImage = Uri.parse(_currentImage).isScheme('file');
    _loadCurrentImage();
  }

  Future<void> _loadCurrentImage() async {
    // Cargar la imagen existente desde Firestore (asume que solo hay una imagen)
    var snapshot = await FirebaseFirestore.instance.collection('images').limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      var doc = snapshot.docs.first;
      setState(() {
        _currentImage = doc['url'];
        _isLocalImage = false;
        _documentId = doc.id; // Guarda el ID del documento
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    XFile? pickedImage = await _picker.pickImage(source: source);

    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);

      try {
        // Subir la imagen a Firebase Storage
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        UploadTask uploadTask = FirebaseStorage.instance
            .ref()
            .child('images/$fileName')
            .putFile(imageFile);

        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Actualizar la URL de la imagen en Firestore
        if (_documentId != null) {
          await FirebaseFirestore.instance.collection('images').doc(_documentId).update({
            'url': downloadUrl,
            'uploaded_at': Timestamp.now(),
          });
        } else {
          DocumentReference docRef = await FirebaseFirestore.instance.collection('images').add({
            'url': downloadUrl,
            'uploaded_at': Timestamp.now(),
          });
          setState(() {
            _documentId = docRef.id; // Guarda el ID del nuevo documento
          });
        }

        setState(() {
          _currentImage = downloadUrl;
          _isLocalImage = false; // La imagen ahora está en línea
        });
      } catch (e) {
        print('Error al subir la imagen: $e');
      }
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
      width: MediaQuery.of(context).size.width * 1, // Ajusta este valor para controlar el ancho
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
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
                      backgroundImage: _isLocalImage
                          ? FileImage(File(_currentImage))
                          : NetworkImage(_currentImage) as ImageProvider,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Bienvenido al Museo Yismer',
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
              widget.onItemTap(0);
            }),
            _buildCircularListTile('Resources/youtube.png', 'Youtubers', () {
              widget.onItemTap(5);
            }),
            _buildCircularListTile('Resources/tik tok.png', 'Influencers', () {
              widget.onItemTap(6);
            }),
            _buildCircularListTile('Resources/twitch.jfif', 'Streamers', () {
              widget.onItemTap(7);
            }),
            _buildCircularListTile('Resources/maps.jfif', 'Convenciones', () {
              widget.onItemTap(2);
            }),
            _buildCircularListTile('Resources/busqueda.jfif', 'Búsqueda', () {
              widget.onItemTap(3);
            }),
            _buildCircularListTile('Resources/ajustes.png', 'Ajustes', () {
              widget.onItemTap(4);
            }),
            _buildCircularListTile('Resources/corazon.png', 'Favoritos', () {
              widget.onItemTap(8);
            }),
            _buildCircularListTile('Resources/logout.jfif', 'Cerrar Sesión', () {
              widget.onItemTap(1);
            }),
            /*_buildCircularListTile('Resources/logout.jfif', 'Mis Publicaciones', () {
              widget.onItemTap(9);
            }),*/
          ],
        ),
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
