

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../CustomViews/CustomDialog.dart';
import '../CustomViews/CustomTextField.dart';




class RegisterView extends StatelessWidget{

  late BuildContext _context;

  TextEditingController usuarioController = TextEditingController();
  TextEditingController passwordMyController = TextEditingController();
  TextEditingController passwordconfirmationMyController = TextEditingController();


  void onClickCancelar(){

    Navigator.of(_context).pushNamed("/loginview");

  }

  void onClickAceptar() async {


    switch(usuarioController.text.isEmpty || passwordMyController.text.isEmpty || passwordconfirmationMyController.text.isEmpty){

      case true:

        CustomDialog.show(_context, "Hay campos vacios, rellenalo todo");
        break;

      case false:

        if(passwordMyController.text == passwordconfirmationMyController.text)
        {
          try {

            await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: usuarioController.text,
              password: passwordMyController.text,
            );

            Navigator.of(_context).pushNamed("/loginview");
          }


          on FirebaseAuthException catch (e) {

            if (e.code == 'weak-password') {

              CustomDialog.show(_context, "La contraseña debe ser superior a 6 caracteres");


            } else if (e.code == 'email-already-in-use') {

              CustomDialog.show(_context, "el email ya existe");


            }

            Navigator.of(_context).pushNamed("/homeview");
          }
          catch (e) {
            print(e);
          }
        }

        else
          {
            CustomDialog.show(_context, "Las contraseñas no son iguales");
          }

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    // TODO: implement build

    return Scaffold(
        appBar: AppBar(
          title: const Text('Registro'),
          centerTitle: true,
          backgroundColor: Colors.amarillotrabajo,
        ),
        backgroundColor: Colors.grey[400],
        body:
        Center(
          child: ConstrainedBox(constraints: BoxConstraints(
            minWidth: 500,
            minHeight: 700,
            maxWidth: 1000,
            maxHeight: 900,
          ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
      Text("Registro",style: TextStyle(fontSize: 25)),


      Padding(padding: EdgeInsets.symmetric(horizontal: 60, vertical: 16),
            child:  customTextField(tecUsername: usuarioController,oscuro: false,sHint: "Usuario",)
      ),

      Padding(padding: EdgeInsets.symmetric(horizontal: 60, vertical: 16),
            child:  customTextField( tecUsername: passwordMyController, oscuro: true,sHint: "Contraseña")
      ),

      Padding(padding: EdgeInsets.symmetric(horizontal: 60, vertical: 16),
            child:  customTextField( tecUsername: passwordconfirmationMyController, oscuro: true, sHint: "Repetir contraseña ",)
      ),

      Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(onPressed: onClickAceptar, child: Text("Aceptar"),),
            TextButton( onPressed: onClickCancelar, child: Text("Cancelar"),)

          ],)

              ],
            ),),
        )
    );
  }

}