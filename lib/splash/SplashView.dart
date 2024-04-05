

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../FirebaseObjects/FbUsuario.dart';
import '../Singletone/DataHolder.dart';


class SplashView extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SplashViewState();
  }
}

class _SplashViewState extends State<SplashView>{

  FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkSession();
  }

  void checkSession() async{
    await Future.delayed(Duration(seconds: 3));

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

        Navigator.of(context).popAndPushNamed("/perfilview");
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
      children: [
        Positioned(
            left: DataHolder().platformAdmin.getScreenWidth()*0.1,
            top: DataHolder().platformAdmin.getScreenHeight()*0.1,
            width: DataHolder().platformAdmin.getScreenWidth()*0.8,
            height: DataHolder().platformAdmin.getScreenHeight()*0.8,
            child: Image.asset("Resources/Museo.png",)
        ),
        Positioned(
            left: DataHolder().platformAdmin.getScreenWidth()*0.1,
            top: DataHolder().platformAdmin.getScreenHeight()*0.1+DataHolder().platformAdmin.getScreenHeight()*0.8,
            child: CircularProgressIndicator()
        ),

      ],
    );
  }
}