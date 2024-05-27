import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  File? _imagePreview;

  @override
  void initState() {
    super.initState();
    conseguirUsuario();
  }

  void conseguirUsuario() async {
    usuario = await conexion.fbadmin.conseguirUsuario();
  }

  Future<void> onGalleyClicked() async {
    final picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePreview = File(image.path);
      });
    }
  }

  Future<void> onCameraClicked() async {
    final picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.camera);
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
    final rutaAFicheroEnNube = storageRef.child(rutaEnNube);
    final metadata = SettableMetadata(contentType: "image/jpeg");

    try {
      await rutaAFicheroEnNube.putFile(_imagePreview!, metadata);
      String url = await rutaAFicheroEnNube.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      print("ERROR AL SUBIR IMAGEN: " + e.toString());
      return "";
    }
  }

  void subirElPost() async {
    conseguirUsuario();

    String imgUrl = await setearUrlImagen();

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
      appBar: AppBar(title: Text(DataHolder().sPublicar)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: customTextField(
                tecUsername: tecTitulo,
                oscuro: false,
                sHint: "Titulo",
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: customTextField(
                tecUsername: tecPost,
                oscuro: false,
                sHint: "Descripcion",
              ),
            ),
            if (_imagePreview != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.file(
                  _imagePreview!,
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: onGalleyClicked,
                child: Text("Seleccionar desde Galería"),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: onCameraClicked,
                child: Text("Tomar una Foto"),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
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
