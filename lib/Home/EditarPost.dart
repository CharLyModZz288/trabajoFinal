import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditarPost extends StatefulWidget {
  final String? postId;
  final String? usuario;
  final String? imagen;
  final String? tituloInicial;
  final String? contenidoInicial;

  EditarPost({
    this.postId,
    this.usuario,
    this.imagen,
    this.tituloInicial,
    this.contenidoInicial,
  });

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
        title: Text("Museo Yismer"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Título:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              _tituloController.text,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Descripción",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              _contenidoController.text,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            if (imagenUrl != null && imagenUrl!.isNotEmpty)
              Image.network(
                imagenUrl!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.contain,
              ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: db
                    .collection('posts')
                    .doc(widget.postId)
                    .collection('comments')
                    .orderBy('fecha', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text(
                      "Todavía no hay comentarios",
                      style: TextStyle(fontSize: 16),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final commentData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(
                              commentData['usuario'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(commentData['texto']),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _comentarioController,
                    decoration: InputDecoration(
                      labelText: 'Escribe un comentario',
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _agregarComentario,
                  child: Text('Enviar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Future<List<Map<String, dynamic>>> getComments(String postId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .get();

    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  void _agregarComentario() async {
    final comentarioTexto = _comentarioController.text;
    final usuarioActual = FirebaseAuth.instance.currentUser;

    if (comentarioTexto.isNotEmpty && usuarioActual != null) {
      String nombreUsuario = usuarioActual.displayName ?? "Anónimo";

      await db.collection('posts').doc(widget.postId).collection('comments').add({
        'usuario': nombreUsuario,
        'texto': comentarioTexto,
        'fecha': DateTime.now(),
        'imagenUrl': imagenUrl,
      });

      _comentarioController.clear();
    }
  }
}
