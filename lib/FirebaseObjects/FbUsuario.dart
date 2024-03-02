import 'package:cloud_firestore/cloud_firestore.dart';

class FbUsuario{

   String nombre;
   int edad;
   String shint;
   //GeoPoint geoloc;

  FbUsuario ({
    required this.nombre,
    required this.edad,
    required this.shint,
    //required this.geoloc,
  });

  factory FbUsuario.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return FbUsuario(
        shint: data?['shint'] != null ? data!['shint'] : "",
        nombre: data?['nombre'] != null ? data!['nombre'] : "",
        edad: data?['edad'] != null ? data!['edad'] : 0,
        //geoloc:data?['geoloc'] != null ? data!['geoloc'] : GeoPoint(0, 0)
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (nombre != null) "nombre": nombre,
      if (edad != null) "edad": edad,
      if (shint != null) "shint": shint,
      //if (geoloc != null) "geoloc": geoloc,
    };
  }
}