import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../FirebaseObjects/FbPostId.dart';
import '../FirebaseObjects/FbUsuario.dart';
import 'FirebaseAdmin.dart';
import 'GeolocAdmin.dart';
import 'HttpAdmin.dart';
import 'PlatformAdmin.dart';

class DataHolder {
  static final DataHolder _dataHolder = DataHolder._internal();

  String sPublicar = "Publicación";
  String sNombre = "Trabajo Final de CarlosEscriva";
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAdmin fbadmin = FirebaseAdmin();
  late FbPostId selectedPost;
  GeolocAdmin geolocAdmin = GeolocAdmin();
  FbUsuario? usuario;
  HttpAdmin httpAdmin = HttpAdmin();
  late PlatformAdmin platformAdmin;

  DataHolder._internal() {}

  void initDataHolder() {}

  factory DataHolder() {
    return _dataHolder;
  }

  Future<FbUsuario?> loadFbUsuario() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    print("UID DE DESCARGA loadFbUsuario------------->>>> ${uid}");
    DocumentReference<FbUsuario> ref = db.collection("Usuarios")
        .doc(uid)
        .withConverter(
      fromFirestore: FbUsuario.fromFirestore,
      toFirestore: (FbUsuario usuario, _) => usuario.toFirestore(),
    );

    DocumentSnapshot<FbUsuario> docSnap = await ref.get();
    print("docSnap DE DESCARGA loadFbUsuario------------->>>> ${docSnap.data()}");
    usuario = docSnap.data();
    return usuario;
  }


  void initPlatformAdmin(BuildContext context) {
    platformAdmin = PlatformAdmin(context: context);
  }

  void insertPostEnFBId(FbPostId postNuevo) {
    CollectionReference<FbPostId> postsRef = db.collection("Posts")
        .withConverter(
      fromFirestore: FbPostId.fromFirestore,
      toFirestore: (FbPostId post, _) => post.toFirestore(),
    );

    postsRef.add(postNuevo);
  }

  void saveSelectedPostInCache() async {
    if (selectedPost != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('postsusuario_surlimg', selectedPost!.sUrlImg);
      prefs.setString('postsusuario_usuario', selectedPost!.usuario);
      prefs.setString('postsusuario_titulo', selectedPost!.titulo);
      prefs.setString('postsusuario_post', selectedPost!.post);
      prefs.setString('postsusuario_IdUsuario', selectedPost!.id);
    }
  }
}
