import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../CustomViews/CustomButton.dart';
import '../CustomViews/CustomTextField.dart';
import '../Singletone/DataHolder.dart';


class PerfilView extends StatefulWidget {
  @override
  _PerfilViewState createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  TextEditingController tecNombre = TextEditingController();
  TextEditingController tecEdad = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;
  late BuildContext _context;
  DataHolder conexion = DataHolder();
  ImagePicker _picker = ImagePicker();
  File _imagePreview = File("");
  String imagenPredefinida = "Resources/logo.jpeg";
  bool mostrarPredefinida = true;

  void onClickAceptar() async {
    setState(() {
      mostrarPredefinida = false;
    });

    String imageUrl = await setearUrlImagen();
    print(imageUrl);
    conexion.fbadmin.anadirUsuario(tecNombre.text, int.parse(tecEdad.text), imageUrl,);
    Navigator.of(_context).popAndPushNamed("/homeview");
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    XFile? pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        _imagePreview = File(pickedImage.path);
        mostrarPredefinida = false;
      });
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
    this._context = context;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: true,
        shadowColor: Colors.purpleAccent,
        backgroundColor: Colors.purple,
      ),
      backgroundColor: Colors.blue[200],
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 500,
            minHeight: 700,
            maxWidth: 1000,
            maxHeight: 900,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                child: customTextField(
                  tecUsername: tecNombre,
                  oscuro: false,
                  sHint: "Usuario",
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                child: customTextField(
                  tecUsername: tecEdad,
                  oscuro: false,
                  sHint: "Edad",
                ),
              ),
              Column(
                children: [
                  if (mostrarPredefinida)
                    Image.asset(
                      imagenPredefinida,
                      width: 300,
                      height: 450,
                    ),
                  if (_imagePreview != null && !mostrarPredefinida)
                    Image.file(
                      _imagePreview,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await _getImage();
                    },
                    child: Text('Imagen'),
                  ),
                  CustomButton(texto: "Aceptar", onPressed: onClickAceptar),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
