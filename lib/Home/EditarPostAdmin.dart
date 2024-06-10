import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../FirebaseObjects/FbPostId.dart';
import '../Singletone/DataHolder.dart';

class EditarPostAdmin extends StatefulWidget {
  final String? postId;
  final String? usuario;
  final String? imagen;
  final String? tituloInicial;
  final String? contenidoInicial;

  EditarPostAdmin({
    this.postId,
    this.usuario,
    this.imagen,
    this.tituloInicial,
    this.contenidoInicial,
  });

  @override
  _EditarPostAdminState createState() => _EditarPostAdminState();
}

class _EditarPostAdminState extends State<EditarPostAdmin> {
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _contenidoController = TextEditingController();
  ImagePicker _picker = ImagePicker();
  FirebaseFirestore db = FirebaseFirestore.instance;
  File _imagePreview = File("");
  late FbPostId post;
  String imagenUrl = "";
  DataHolder conexion = DataHolder();
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _tituloController.text = widget.tituloInicial ?? '';
    _contenidoController.text = widget.contenidoInicial ?? '';
    imagenUrl = widget.imagen ?? "";
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
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
    if (_isDisposed) return;

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

    final rutaAFicheroEnNube = storageRef.child(rutaEnNube);

    final metadata = SettableMetadata(contentType: "image/jpeg");
    try {
      await rutaAFicheroEnNube.putFile(_imagePreview, metadata);

      String url = await rutaAFicheroEnNube.getDownloadURL();
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
        title: Text('Editar Post'),
        actions: [
          IconButton(
            onPressed: () async {
              // Mostrar un cuadro de diálogo de confirmación para borrar la publicación
              bool confirmacion = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Confirmar Eliminación'),
                    content: Text('¿Estás seguro de que deseas eliminar esta publicación?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false); // Cerrar el diálogo
                        },
                        child: Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true); // Cerrar el diálogo
                        },
                        child: Text('Eliminar'),
                      ),
                    ],
                  );
                },
              );

              if (confirmacion == true) {
                // Eliminar la publicación de la base de datos
                await conexion.fbadmin.deletePostData(widget.postId.toString());
                // Cerrar la pantalla actual
                Navigator.of(context).pop();
              }
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Título: " + _tituloController.text),
            Text("Contenido: " + _contenidoController.text),
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
                                  setState(() {
                                    _tituloController.text = value;
                                  });
                                },
                                decoration: InputDecoration(labelText: 'Nuevo Título'),
                              ),
                              TextField(
                                onChanged: (value) {
                                  setState(() {
                                    _contenidoController.text = value;
                                  });
                                },
                                decoration: InputDecoration(labelText: 'Nuevo Contenido'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  await updateImageCamera();
                                },
                                child: Text('Seleccionar Imagen desde cámara'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  await updateImage();
                                },
                                child: Text('Seleccionar Imagen desde galería'),
                              ),
                            ],
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () async {
                                // Actualizar los datos en Firebase
                                await conexion.fbadmin.updatePostData(
                                  _tituloController.text,
                                  _contenidoController.text,
                                  imagenUrl,
                                  widget.usuario.toString(),
                                  widget.postId.toString(),
                                );
                                // Cerrar el diálogo
                                Navigator.of(context).pop();
                                // Actualizar el estado para reflejar los cambios
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
            )
          ],
        ),
      ),
    );
  }
}
