
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../FirebaseObjects/FbUsuario.dart';


class FirebaseAdmin {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  FbUsuario? usuario;

  Future<FbUsuario?> loadFbUsuario() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference<FbUsuario> ref = db.collection("Usuarios")
        .doc(uid)
        .withConverter(fromFirestore: FbUsuario.fromFirestore,
      toFirestore: (FbUsuario usuario, _) => usuario.toFirestore(),);


    DocumentSnapshot<FbUsuario> docSnap = await ref.get();
    usuario = docSnap.data();
    return usuario;
  }


  Future<void> updateUserPost(String Titulo, int post, String imagen) async {


  }


  Future<void> anadirUsuario(String nombre, int edad, String img,int loginCount) async {
    FbUsuario usuario = new FbUsuario(nombre: nombre, edad: edad, shint: img, loginCount: loginCount,);
    String uidUsuario = FirebaseAuth.instance.currentUser!.uid;
    await db.collection("Usuarios").doc(uidUsuario).set(usuario.toFirestore());
  }

  Future<bool> existenDatos() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot<Map<String, dynamic>> datos = await
    db.collection("Usuarios").doc(uid).get();

    if (datos.exists) {
      return true;
    }
    else {
      return false;
    }
  }


  Future<List<Map<String, dynamic>>> searchPostsByTitle(String searchValue) async {
    QuerySnapshot querySnapshot = await db
        .collection('PostUsuario')
        .where('Titulo', isGreaterThanOrEqualTo: searchValue)
        .get();

    return querySnapshot.docs
        .where((doc) =>
    (doc['Titulo'] as String).contains(searchValue) ||
        (doc['Usuario'] as String).contains(searchValue))
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<FbUsuario> conseguirUsuario() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    print(uid);

    DocumentReference<FbUsuario> enlace = db.collection("Usuarios").doc(
        uid).withConverter(fromFirestore: FbUsuario.fromFirestore,
      toFirestore: (FbUsuario usuario, _) => usuario.toFirestore(),);

    FbUsuario usuario;

    DocumentSnapshot<FbUsuario> docSnap = await enlace.get();
    usuario = docSnap.data()!;

    return usuario;
  }

  Future<void> updateUserData(String nombre, int edad, String imagen,int loginCount) async {
    FbUsuario usuario = FbUsuario(nombre: nombre, edad: edad, shint: imagen, loginCount: loginCount);
    String uidUsuario = FirebaseAuth.instance.currentUser!.uid;
    await db.collection("Usuarios").doc(uidUsuario).set(usuario.toFirestore());
  }

  Future<void> updatePostData(String titulo, String postContenido, String imagenUrl, String nombre, String postId) async {


    print("ffffffffffffffffffffffffffffffffffff" + postId);
    DocumentReference<Map<String, dynamic>> postRef = db.collection("PostUsuario").doc(postId);
    // Obtener el documento actual
    DocumentSnapshot<Map<String, dynamic>> postSnapshot = await postRef.get();

    if (postSnapshot.exists) {
      // Crear un mapa con los datos actualizados del post
      Map<String, dynamic> postData = {
        'sUrlImg': imagenUrl,
        'Usuario': nombre,
        'Titulo': titulo,
        'Post': postContenido,
        'Idpost' : postId,
        // Agrega aquí otros campos si los tienes
      };

      await postRef.update(postData);
    } else {
      print("No se encontró el documento con el ID proporcionado.");
      print(postId.toString());
    }
  }
  Future<String?> getPostReferenceByImagen(String codigoReferenciaImagen) async {
    String uidUsuario = FirebaseAuth.instance.currentUser!.uid;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("PostUsuario")
        .where('sUrlImg', isEqualTo: codigoReferenciaImagen)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String postId = querySnapshot.docs.first.id;

      return postId;
    }

    return null;
  }
}