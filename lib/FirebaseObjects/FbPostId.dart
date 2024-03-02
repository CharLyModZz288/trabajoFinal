import 'package:cloud_firestore/cloud_firestore.dart';

class FbPostId{


  final String post;
  final String usuario;
  final String titulo;
  final String sUrlImg;
  final String id;

  FbPostId ({
    required this.post,
    required this.usuario,
    required this.titulo,
    required this.sUrlImg,
    required this.id,
  });



  factory FbPostId.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return FbPostId(
        sUrlImg: data?['sUrlImg'] != null ? data!['sUrlImg'] : "",
         usuario: data?['Usuario'],
        titulo: data?['Titulo'],
        post: data?['Post'],
        id: data?['IdUsuario'],

    );
  }
  FbPostId copyWith({
    String? id,
    String? post,
    String? usuario,
    String? titulo,
    String? sUrlImg,
  }) {
    return FbPostId(
      id: id ?? this.id,
      post: post ?? this.post,
      usuario: usuario ?? this.usuario,
      titulo: titulo ?? this.titulo,
      sUrlImg: sUrlImg ?? this.sUrlImg,
    );
  }


  Map<String, dynamic> toFirestore() {
    return {
      if (sUrlImg != null) "sUrlImg": sUrlImg,
      if (usuario != null) "Usuario": usuario,
      if (titulo != null) "Titulo": titulo,
      if (post != null) "Post": post,
      if (id != null) "IdUsuario": id,
    };
  }
}