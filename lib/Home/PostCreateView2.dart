
import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../CustomViews/CustomTextField.dart';
import '../FirebaseObjects/FbPostId.dart';
import '../FirebaseObjects/FbUsuario.dart';
import '../Singletone/DataHolder.dart';
import 'package:image_picker/image_picker.dart';




class PostCreateView2 extends StatefulWidget{
  @override
  State<PostCreateView2> createState() => _PostCreateViewState();
}

class _PostCreateViewState extends State<PostCreateView2> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController tecTitulo=TextEditingController();
  TextEditingController tecPost=TextEditingController();
  late FbUsuario usuario;
  DataHolder conexion= DataHolder();

  String id=".";
  String nombreUsuario = ".";

  ImagePicker _picker = ImagePicker();
  File _imagePreview=File("");

  String imgUrl="";

  @override
  void initState() {
    super.initState();
    conseguirUsuario();
  }

  void onGalleyClicked() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePreview = File(image.path);
      });
    }
  }

  void onCameraClicked() async {
    XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _imagePreview = File(image.path);
      });
    }
  }

  void conseguirUsuario() async {
    usuario = await conexion.fbadmin.conseguirUsuario();
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
      Navigator.of(context).popAndPushNamed("/homeview2");
      // Obtén la URL de la imagen después de subirla
      String url = await rutaAFicheroEnNube.getDownloadURL();
      print("URL de la imagen: $url");
      return url;
    } on FirebaseException catch (e) {
      print("ERROR AL SUBIR IMAGEN: " + e.toString());
      print("STACK TRACE: " + e.stackTrace.toString());
      return "";
    }
  }

  void subirElPost() async {
    conseguirUsuario();

    // Setea la URL de la imagen
    imgUrl = await setearUrlImagen();

    FbPostId postNuevo = FbPostId(
      post: tecPost.text,
      usuario: usuario.nombre,
      titulo: tecTitulo.text,
      sUrlImg: imgUrl,
      id: "", // se deja en blanco porque se va a introducir luego
    );

    CollectionReference<FbPostId> postsRef = db
        .collection("Youtubers")
        .withConverter(
      fromFirestore: FbPostId.fromFirestore,
      toFirestore: (FbPostId post, _) => post.toFirestore(),
    );

    DocumentReference<FbPostId> postDocRef = await postsRef.add(postNuevo);

    String postId = postDocRef.id;
    print("El ID del nuevo post es: $postId");

    postNuevo = postNuevo.copyWith(id: postId);
    await postDocRef.update(postNuevo.toFirestore());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(DataHolder().sNombre)),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: customTextField(
              tecUsername: tecTitulo,
              oscuro: false,
              sHint: "Titulo",
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: customTextField(
              tecUsername: tecPost,
              oscuro: false,
              sHint: "Contenido",
            ),
          ),
          TextButton(
            onPressed: onGalleyClicked,
            child: Text("Galeria"),
          ),
          TextButton(
            onPressed: onCameraClicked,
            child: Text("Cámara"),
          ),
          TextButton(
            onPressed: subirElPost,
            child: Text("Subir"),
          ),
        ],
      ),
    );
  }
}