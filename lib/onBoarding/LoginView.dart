import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../CustomViews/CustomButton.dart';
import '../CustomViews/CustomDialog.dart';
import '../CustomViews/CustomTextField.dart';
import '../Singletone/DataHolder.dart';

class LoginView extends StatelessWidget {

  FirebaseFirestore db = FirebaseFirestore.instance;
  late BuildContext _context;
  DataHolder conexion = DataHolder();

  TextEditingController usuarioControlador = TextEditingController();
  TextEditingController usuarioPassword = TextEditingController();

  void onClickTermsAndConditions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Términos y condiciones'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Términos y Condiciones',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  '1. Uso de la Aplicación:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Esta aplicación está destinada únicamente para uso personal y no comercial. No se permite el uso de esta aplicación para actividades ilegales o inapropiadas.',
                ),
                SizedBox(height: 10),
                Text(
                  '2. Contenido y Propiedad Intelectual:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Todos los derechos de propiedad intelectual del contenido de esta aplicación son propiedad de [Nombre de la Empresa] y están protegidos por las leyes de derechos de autor. No se permite la reproducción o distribución no autorizada del contenido.',
                ),
                SizedBox(height: 10),
                Text(
                  '3. Responsabilidad del Usuario:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'El usuario es responsable de mantener la confidencialidad de su información de inicio de sesión y de todas las actividades que ocurran bajo su cuenta. Museo YISMER no será responsable de ninguna pérdida o daño derivado del incumplimiento de esta obligación por parte del usuario.',
                ),
                // Agrega más secciones de términos y condiciones según sea necesario
              ],
            ),
          ),

          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }


  void onClickPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Política de privacidad'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Política de Privacidad',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  '1. Información Recopilada:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Recopilamos información personal como nombres, direcciones de correo electrónico y preferencias de usuario cuando los usuarios se registran en nuestra aplicación o realizan compras a través de ella. También recopilamos datos de uso, como la actividad del usuario y las interacciones con la aplicación.',
                ),
                SizedBox(height: 10),
                Text(
                  '2. Uso de la Información:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Utilizamos la información recopilada para proporcionar y mejorar nuestros servicios, personalizar la experiencia del usuario y comunicarnos con los usuarios. No compartimos información personal con terceros sin el consentimiento del usuario, excepto cuando sea necesario para proporcionar servicios solicitados por el usuario.',
                ),
                SizedBox(height: 10),
                Text(
                  '3. Seguridad de los Datos:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Implementamos medidas de seguridad para proteger la información personal de nuestros usuarios contra accesos no autorizados, alteraciones, divulgaciones o destrucciones no autorizadas. Sin embargo, no podemos garantizar la seguridad absoluta de la información transmitida a través de Internet.',
                ),
                // Agrega más secciones de la política de privacidad según sea necesario
              ],
            ),
          ),

          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void onClickRegistrar(){
    Navigator.of(_context).pushNamed("/registerview");
  }
  void onClickRegistrarConMovil(){
    Navigator.of(_context).pushNamed("/phoneloginview");
  }

  void onClickAceptar() async {

    if (usuarioControlador.text.isEmpty || usuarioPassword.text.isEmpty) {
      CustomDialog.show(_context, "No está todo relleno, compruébalo");
      return;
    }

    try {
      // Inicia sesión con las credenciales
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: usuarioControlador.text,
          password: usuarioPassword.text
      );

      if (credential.user?.email == 'administrador@administrador.com') {
        Navigator.of(_context).popAndPushNamed("/homeadmin");
      } else {
        if (await conexion.fbadmin.existenDatos()){
          Navigator.of(_context).popAndPushNamed("/homeview");
        } else {
          Navigator.of(_context).popAndPushNamed("/perfilview");
        }
      }

    } on FirebaseAuthException catch (e) {
      // Maneja los errores de autenticación
      CustomDialog.show(_context, "Usuario o contraseña incorrectos");

      if (e.code == 'user-not-found') {
        CustomDialog.show(_context, "El usuario no existe");
      } else if (e.code == 'wrong-password') {
        CustomDialog.show(_context, "Contraseña incorrecta");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    // Construcción de la vista
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
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
                Text("Bienvenido al Museo Yismer", style: TextStyle(fontSize: 25)),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                    child: customTextField(
                      tecUsername: usuarioControlador,
                      oscuro: false,
                      sHint: "Usuario",
                    )
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                    child: customTextField(
                      tecUsername: usuarioPassword,
                      oscuro: true,
                      sHint: "Contraseña",
                    )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(onPressed: onClickAceptar, texto: 'Aceptar',),
                    CustomButton(onPressed: onClickRegistrar, texto: 'Registrarse',),
                    CustomButton(onPressed: onClickRegistrarConMovil, texto: 'Registrarse con móvil',),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      onPressed: () => onClickTermsAndConditions(context), // Corregido aquí
                      texto: 'Términos y condiciones',
                    ),
                    CustomButton(
                      onPressed: () => onClickPrivacyPolicy(context), // Ejemplo de otro botón, sin cambios
                      texto: 'Politicas de privacidad',
                    ),
                  ],
                ),

              ],
            ),
          ),
        ));
  }
}
