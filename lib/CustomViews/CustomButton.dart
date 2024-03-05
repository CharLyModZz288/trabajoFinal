import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  // Función llamada cuando se hace clic en uno de los botones de íconos
  final Function(int indice)? onBotonesClicked;

  // Función llamada cuando se hace clic en el botón de texto
  final Function()? onPressed;

  // Texto mostrado en el botón de texto
  final String texto;

  CustomButton({
    Key? key,
    this.onBotonesClicked,
    this.onPressed,
    required this.texto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      // Distribuye los elementos hijos de la fila horizontal uniformemente
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Si hay una función asignada a onBotonesClicked, muestra dos botones de íconos
        if (onBotonesClicked != null)
          ...[
            // Botón de ícono 1
            TextButton(
              onPressed: onBotonesClicked != null ? () => onBotonesClicked!(0) : null,
              child: Icon(Icons.list, color: Colors.orange),
            ),
            // Botón de ícono 2
            TextButton(
              onPressed: onBotonesClicked != null ? () => onBotonesClicked!(1) : null,
              child: Icon(Icons.grid_view, color: Colors.orange),
            ),
          ],
        // Si hay una función asignada a onPressed, muestra un botón de texto
        if (onPressed != null)
        // Botón de texto
          TextButton(
            onPressed: () {
              onPressed!();
            },
            child: Text(texto),
          ),
      ],
    );
  }
}
