import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyPhotosView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Mis Fotos"),
        ),
        body: Center(
          child: Text("Por favor inicia sesión para ver tus fotos"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Mis Fotos"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Usuarios')
            .doc(user.uid)
            .collection('photos')
            .orderBy('fecha', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No tienes fotos"));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final photoData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return GestureDetector(
                onTap: () {
                  // Aquí puedes agregar la navegación a la vista detallada de la foto si lo deseas
                },
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: GridTile(
                    child: photoData['url'] != null && photoData['url'].isNotEmpty
                        ? Image.network(
                      photoData['url'],
                      fit: BoxFit.cover,
                    )
                        : Container(
                      color: Colors.grey,
                      child: Icon(Icons.image, size: 50, color: Colors.white),
                    ),
                    footer: GridTileBar(
                      backgroundColor: Colors.black54,
                      title: Text(
                        photoData['titulo'] ?? 'Sin título',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
