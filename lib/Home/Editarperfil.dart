import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../FirebaseObjects/FbUsuario.dart';
import '../Singletone/DataHolder.dart';

class Editarperfil extends StatefulWidget {
  @override
  _EditarperfilState createState() => _EditarperfilState();
}

class _EditarperfilState extends State<Editarperfil> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  late FbUsuario usuario;
  DataHolder conexion = DataHolder();
  String userId = " ";
  String nombre = " ";
  int edad = 0;
  String imagen = " ";
  ImagePicker _picker = ImagePicker();
  File _imagePreview = File("");

  @override
  void initState() {
    super.initState();
    cargarUsuario();
  }

  Future<void> cargarUsuario() async {
    usuario = await conexion.fbadmin.conseguirUsuario();
    setState(() {
      nombre = usuario.nombre;
      edad = usuario.edad;
    });
  }

  Future<void> updateImage() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePreview = File(image.path);
      });
    }
  }

  Future<void> updateImageCamera() async {
    XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _imagePreview = File(image.path);
      });
    }
  }

  Future<String> setearUrlImagen() async {
    final storageRef = FirebaseStorage.instance.ref();
    String rutaEnNube = "usuarios/" +
        FirebaseAuth.instance.currentUser!.uid +
        "/imgs/" +
        DateTime.now().millisecondsSinceEpoch.toString() +
        ".jpg";
    final rutaAFicheroEnNube = storageRef.child(rutaEnNube);
    final metadata = SettableMetadata(contentType: "image/jpeg");
    try {
      await rutaAFicheroEnNube.putFile(_imagePreview, metadata);
      String url = await rutaAFicheroEnNube.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      print("ERROR AL SUBIR IMAGEN: " + e.toString());
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Perfil"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (imagen != " ")
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(imagen),
                ),
              SizedBox(height: 20),
              Text(
                "Nombre: $nombre",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Edad: $edad",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.deepPurpleAccent,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Modificar Datos'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              onChanged: (value) {
                                nombre = value;
                              },
                              decoration: InputDecoration(labelText: 'Nuevo Nombre'),
                            ),
                            TextField(
                              onChanged: (value) {
                                edad = int.tryParse(value) ?? 0;
                              },
                              decoration: InputDecoration(labelText: 'Nueva Edad'),
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(height: 10),
                            ElevatedButton.icon(
                              onPressed: updateImage,
                              icon: Icon(Icons.photo),
                              label: Text('Galería'),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
                            ),
                            ElevatedButton.icon(
                              onPressed: updateImageCamera,
                              icon: Icon(Icons.camera),
                              label: Text('Cámara'),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
                            ),
                          ],
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              if (_imagePreview.existsSync()) {
                                imagen = await setearUrlImagen();
                              }
                              await conexion.fbadmin.updateUserData(nombre, edad, imagen);
                              await cargarUsuario();
                              setState(() {});
                            },
                            child: Text('Guardar Cambios'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Modificar Datos'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
