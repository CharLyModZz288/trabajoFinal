import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../CustomViews/CustomTextField.dart';
import '../FirebaseObjects/FbPostId.dart';
import '../FirebaseObjects/FbUsuario.dart';
import '../Singletone/DataHolder.dart';

class PostCreateView extends StatefulWidget {
  @override
  State<PostCreateView> createState() => _PostCreateViewState();
}

class _PostCreateViewState extends State<PostCreateView> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController tecTitulo = TextEditingController();
  TextEditingController tecPost = TextEditingController();
  late FbUsuario usuario;
  DataHolder conexion = DataHolder();

  String id = ".";
  String nombreUsuario = ".";

  ImagePicker _picker = ImagePicker();
  File? _imagePreview;

  String imgUrl = "";

  @override
  void initState() {
    super.initState();
    conseguirUsuario();
  }

  void conseguirUsuario() async {
    usuario = await conexion.fbadmin.conseguirUsuario();
  }

  Future<void> onGalleyClicked() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePreview = File(image.path);
      });
    }
  }

  Future<void> onCameraClicked() async {
    XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _imagePreview = File(image.path);
      });
    }
  }

  Future<String> setearUrlImagen() async {
    if (_imagePreview == null) {
      return "";
    }

    final storageRef = FirebaseStorage.instance.ref();
    String rutaEnNube = "posts/" + FirebaseAuth.instance.currentUser!.uid + "/imgs/" + DateTime.now().millisecondsSinceEpoch.toString() + ".jpg";
    print("RUTA DONDE VA A GUARDARSE LA IMAGEN: " + rutaEnNube);

    final rutaAFicheroEnNube = storageRef.child(rutaEnNube);
    final metadata = SettableMetadata(contentType: "image/jpeg");

    try {
      await rutaAFicheroEnNube.putFile(_imagePreview!, metadata);
      print("SE HA SUBIDO LA IMAGEN");

      // Obtén la URL de la imagen después de subirla
      String url = await rutaAFicheroEnNube.getDownloadURL();
      print("URL de la imagen: $url");
      return url;
    } on FirebaseException catch (e) {
      print("ERROR AL SUBIR IMAGEN: " + e.toString());
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
      id: "",
    );

    CollectionReference<FbPostId> postsRef = db.collection("PostUsuario").withConverter(
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
      body: SingleChildScrollView(
        child: Column(
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
            if (_imagePreview != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Image.file(
                  _imagePreview!,
                  width: 150, // Ajusta el ancho de la imagen según tus necesidades
                  fit: BoxFit.cover, // Ajusta la imagen para que se adapte al tamaño especificado
                ),
              ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: onGalleyClicked,
                  child: Text("Galería"),
                ),
                TextButton(
                  onPressed: onCameraClicked,
                  child: Text("Cámara"),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                onPressed: subirElPost,
                child: Text("Subir"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
