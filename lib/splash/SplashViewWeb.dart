

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../FirebaseObjects/FbUsuario.dart';
import '../Singletone/DataHolder.dart';


class SplashViewWeb extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SplashViewWebState();
  }
}

class _SplashViewWebState extends State<SplashViewWeb>{

  FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkSession();
  }
  void checkSession() async{
    await Future.delayed(Duration(seconds: 0));
    if (FirebaseAuth.instance.currentUser != null) {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference<FbUsuario> enlace = db.collection("Usuarios").doc(uid).withConverter(fromFirestore: FbUsuario.fromFirestore,
        toFirestore: (FbUsuario usuario, _) => usuario.toFirestore(),);
      FbUsuario usuario;
      DocumentSnapshot<FbUsuario> docSnap = await enlace.get();
      usuario = docSnap.data()!;
      if (usuario != null) {
        Navigator.of(context).popAndPushNamed("/homeview");
      }
      else{
        Navigator.of(context).popAndPushNamed("/homeview");
      }
    }
    else{
      Navigator.of(context).popAndPushNamed("/loginview");
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(

    );
  }
}