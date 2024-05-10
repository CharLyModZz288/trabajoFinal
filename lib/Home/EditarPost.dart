import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditarPost extends StatefulWidget {
  final String? postId;
  final String? usuario;
  final String? imagen;
  final String? tituloInicial; // Agregado
  final String? contenidoInicial; // Agregado

  EditarPost({this.postId, this.usuario, this.imagen, this.tituloInicial, this.contenidoInicial});

  @override
  _EditarPostState createState() => _EditarPostState();
}

class _EditarPostState extends State<EditarPost> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _contenidoController = TextEditingController();
  final TextEditingController _comentarioController = TextEditingController();
  final FirebaseFirestore db = FirebaseFirestore.instance;

  String? imagenUrl;

  @override
  void initState() {
    super.initState();
    _tituloController.text = widget.tituloInicial ?? '';
    _contenidoController.text = widget.contenidoInicial ?? '';
    imagenUrl = widget.imagen;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Post"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mostrar título y contenido
            Text("Título: ${_tituloController.text}"),
            Text("Contenido: ${_contenidoController.text}"),
            SizedBox(height: 20),
            // Mostrar imagen
            if (imagenUrl != null && imagenUrl!.isNotEmpty)
              Image.network(
                imagenUrl!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.contain,
              ),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: db.collection('comentarios')
                      .doc(widget.postId)
                    .collection('comments')
                    .where('imagenUrl', isEqualTo: imagenUrl)
                    .orderBy('fecha', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text("Todavia no hay comentarios");
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final commentData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                      return ListTile(
                        title: Text(commentData['usuario']),
                        subtitle: Text(commentData['texto']),
                      );
                    },
                  );
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: _comentarioController,
                    decoration: InputDecoration(
                      labelText: 'Escribe un comentario',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _agregarComentario,
                  child: Text('Enviar'),
                ),
              ],
            )

          ],
        ),
      ),
    );
  }

  // Método para agregar un comentario a la imagen de la publicación
  void _agregarComentario() async {
    final comentarioTexto = _comentarioController.text;
    final usuarioActual = FirebaseAuth.instance.currentUser?.displayName ?? "Anónimo";

    if (comentarioTexto.isNotEmpty) {
      // Agregar comentario a Firestore, asociado al postId e imagenUrl
      await db.collection('posts')
          .doc(widget.postId)
          .collection('comments')
          .add({
        'usuario': usuarioActual,
        'texto': comentarioTexto,
        'fecha': DateTime.now(),
        'imagenUrl': imagenUrl, // Añadir la imagenUrl
      });

      // Limpia el campo de entrada después de enviar
      _comentarioController.clear();
    }
  }

}
