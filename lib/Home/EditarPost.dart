

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
  final String? tituloInicial; // Agregado
  final String? contenidoInicial; // Agregado

  EditarPost({this.postId, this.usuario, this.imagen,this.tituloInicial,this.contenidoInicial});

  @override
  _EditarPostState createState() => _EditarPostState();
}

class _EditarPostState extends State<EditarPost> {
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _contenidoController = TextEditingController();
  ImagePicker _picker = ImagePicker();
  FirebaseFirestore db = FirebaseFirestore.instance;
  File _imagePreview = File("");
  late FbPostId post;
  String userId = " ";
  String usuario = " ";
  String titulo = " "; // Inicializa la variable
  String postContenido = " "; // Inicializa la variable
  String imagenUrl = " ";
  DataHolder conexion = DataHolder();
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    // Inicializa los controladores de texto y las variables
    _tituloController.text = widget.tituloInicial ?? '';
    _contenidoController.text = widget.contenidoInicial ?? '';

    // Establece los valores iniciales para titulo y postContenido
    titulo = widget.tituloInicial ?? '';
    postContenido = widget.contenidoInicial ?? '';

    imagenUrl = widget.imagen ?? '';
  }


  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
    // Imprimir el ID del post en el método dispose
    print(widget.postId.toString());
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
            // Muestra los valores de título y contenido
            Text("Título: $titulo"),
            Text("Contenido: $postContenido"),
            SizedBox(height: 20),
            // Muestra la imagen si la URL es válida
            if (imagenUrl.isNotEmpty)
              Image.network(
                imagenUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.contain,
              ),
            // Agrega más widgets o funciones según sea necesario
          ],
        ),
      ),
    );
  }

}
