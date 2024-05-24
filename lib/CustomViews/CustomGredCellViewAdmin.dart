import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Home/EditarPost.dart';
import '../Home/EditarPostAdmin.dart';


class CustomGredCellViewAdmin extends StatelessWidget{

  final String sText;
  final String usuario;
  final String tituloPost;
  final int iColorCode;
  final String imagen;
  final double dFontSize;
  final String idPost;
  final String contenido;

  const CustomGredCellViewAdmin({
    Key? key,
    required this.sText,
    required this.iColorCode,
    required this.imagen,
    required this.dFontSize,
    required this.usuario,
    required this.idPost,
    required this.tituloPost,
    required this.contenido,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 200.0,
        crossAxisSpacing: 200.0,
      ),
      padding: const EdgeInsets.all(8.0),
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            print("Clic en la imagen");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditarPostAdmin(
                    postId: idPost,
                    usuario: usuario,
                    imagen: imagen,
                    tituloInicial: tituloPost,
                    contenidoInicial: contenido,
                ),
              ),
            );
          },
          child: Container(
            color: Colors.naranjatrabajo, // Cambié el color a beige
            child: Stack(
              children: [
                if (imagen.isNotEmpty) ...[
                  SizedBox(
                    width: double.infinity,
                    child: Image.network(
                      imagen,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        usuario,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
                Positioned(
                  bottom: 16.0,
                  left: 5,
                  child: Text(
                    tituloPost,
                    style: TextStyle(
                      fontSize: dFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

