

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../FirebaseObjects/FbPostId.dart';
import '../Singletone/DataHolder.dart';

class EditarPost extends StatefulWidget {
  String? postId;
  String? usuario;
  String? imagen;

  EditarPost({this.postId, this.usuario, this.imagen});

  @override
  _EditarPostState createState() => _EditarPostState();
}

class _EditarPostState extends State<EditarPost> {
  ImagePicker _picker = ImagePicker();
  FirebaseFirestore db = FirebaseFirestore.instance;
  File _imagePreview = File("");
  late FbPostId post;
  String userId = " ";
  String usuario = " ";
  String titulo = " ";
  String postContenido = " ";
  String imagenUrl = " ";
  DataHolder conexion = DataHolder();
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
    print(widget.postId.toString()); // Use widget.postId here
  }

  Future<void> updateImage() async {
    if (_isDisposed) return;

    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePreview = File(image.path);
      });

      String newImageUrl = await setearUrlImagen();

      if (!_isDisposed) {
        setState(() {
          imagenUrl = newImageUrl;
        });
      }
    }
  }


  Future<void> updateImageCamera() async {

    print("el usuario es:" + widget.postId.toString());
    if (_isDisposed) return; // Verificar si el widget ha sido eliminado

    XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _imagePreview = File(image.path);
      });

      String newImageUrl = await setearUrlImagen();

      if (!_isDisposed) {
        setState(() {
          imagenUrl = newImageUrl;
        });
      }
    }
  }

  Future<String> setearUrlImagen() async {
    final storageRef = FirebaseStorage.instance.ref();

    String rutaEnNube =
        "posts/" + FirebaseAuth.instance.currentUser!.uid + "/imgs/" +
            DateTime.now().millisecondsSinceEpoch.toString() + ".jpg";
    print("RUTA DONDE VA A GUARDARSE LA IMAGEN: " + rutaEnNube);

    final rutaAFicheroEnNube = storageRef.child(rutaEnNube);

    final metadata = SettableMetadata(contentType: "image/jpeg");
    try {
      await rutaAFicheroEnNube.putFile(_imagePreview, metadata);

      print("SE HA SUBIDO LA IMAGEN");

      String url = await rutaAFicheroEnNube.getDownloadURL();
      print("URL de la imagen: $url");
      return url;
    } on FirebaseException catch (e) {
      print("ERROR AL SUBIR IMAGEN: " + e.toString());
      print("STACK TRACE: " + e.stackTrace.toString());
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DataHolder().sNombre),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Título: " + titulo),
            Text("Contenido: " + postContenido),
            SizedBox(height: 20),
            if (imagenUrl != " ")
              Image.network(
                imagenUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.contain,
              ),
            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Mostrar un cuadro de diálogo para que el usuario ingrese nuevos datos
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Modificar Datos del Post'),
                          content: Column(
                            children: [
                              TextField(
                                onChanged: (value) {
                                  titulo = value;
                                },
                                decoration: InputDecoration(labelText: 'Nuevo Título'),
                              ),
                              TextField(
                                onChanged: (value) {
                                  postContenido = value;
                                },
                                decoration: InputDecoration(labelText: 'Nuevo Contenido'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  await updateImageCamera();
                                },
                                child: Text('Seleccionar Imagen desde camera'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  await updateImage();
                                },
                                child: Text('Foto desde galeria'),
                              ),
                            ],
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                conexion.fbadmin.updatePostData(titulo, postContenido, imagenUrl, widget.usuario.toString(), widget.postId.toString());
                                print( imagenUrl);
                                setState(() {});
                              },
                              child: Text('Guardar Cambios'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Modificar Datos del Post'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  }