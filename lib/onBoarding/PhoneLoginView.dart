import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../CustomViews/CustomPhoneTextField.dart';
import '../FirebaseObjects/FbUsuario.dart';
import '../Singletone/DataHolder.dart';

class PhoneLoginView extends StatefulWidget {
  @override
  State<PhoneLoginView> createState() => _PhoneLoginViewState();
}

class _PhoneLoginViewState extends State<PhoneLoginView> {
  final TextEditingController tecPhone = TextEditingController();
  final TextEditingController tecVerify = TextEditingController();
  String sVerificationCode = "";
  bool blMostrarVerificacion = false;

  void enviarTelefonoPressed() async {
    // Obtenemos el número de teléfono ingresado
    String sTelefono = tecPhone.text.trim();

    // Verificamos el número de teléfono
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: sTelefono,
      verificationCompleted: verificacionCompletada,
      verificationFailed: verificacionFallida,
      codeSent: codigoEnviado,
      codeAutoRetrievalTimeout: tiempoDeEsperaAcabado,
    );
  }

  void enviarVerifyPressed() async {
    // Obtenemos el código de verificación ingresado
    String smsCode = tecVerify.text.trim();

    // Creamos la credencial de autenticación con el código de verificación
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: sVerificationCode,
      smsCode: smsCode,
    );

    // Iniciamos sesión con la credencial de autenticación
    await FirebaseAuth.instance.signInWithCredential(credential);

    // Cargamos el usuario de Firebase
    FbUsuario? usuario = await DataHolder().loadFbUsuario();

    // Navegamos según el resultado
    if (usuario != null) {
      print("EL NOMBRE DEL USUARIO LOGEADO ES: ${usuario.nombre}");
      print("LA EDAD DEL USUARIO LOGEADO ES: ${usuario.edad}");
      Navigator.of(context).popAndPushNamed("/homeview");
    } else {
      Navigator.of(context).popAndPushNamed("/perfilview");
    }
  }

  void verificacionCompletada(PhoneAuthCredential credential) async {
    // Autenticar al usuario automáticamente si se completa la verificación
    await FirebaseAuth.instance.signInWithCredential(credential);

    // Cargamos el usuario de Firebase
    FbUsuario? usuario = await DataHolder().loadFbUsuario();

    // Navegamos según el resultado
    if (usuario != null) {
      print("EL NOMBRE DEL USUARIO LOGEADO ES: ${usuario.nombre}");
      print("LA EDAD DEL USUARIO LOGEADO ES: ${usuario.edad}");
      Navigator.of(context).popAndPushNamed("/homeview");
    } else {
      Navigator.of(context).popAndPushNamed("/perfilview");
    }
  }

  void verificacionFallida(FirebaseAuthException excepcion) {
    // Manejo de errores de verificación
    if (excepcion.code == 'invalid-phone-number') {
      print('El número de teléfono proporcionado no es válido.');
    } else {
      print('Error de verificación de número de teléfono: ${excepcion.message}');
    }
  }

  void codigoEnviado(String codigo, int? resendToken) async {
    // Guardamos el código de verificación enviado por SMS
    sVerificationCode = codigo;

    // Mostramos el campo de verificación en la interfaz de usuario
    setState(() {
      blMostrarVerificacion = true;
    });
  }

  void tiempoDeEsperaAcabado(String verID) {
    // Este método se ejecuta cuando el tiempo de espera de la verificación automática ha expirado.
    // Puedes agregar lógica aquí si es necesario.
    print("Tiempo de espera de verificación automática ha expirado.");
  }

  void onClickCancelar() {
    // Manejo del botón de cancelar
    Navigator.of(context).pushNamed("/loginview");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomPhoneTextField(
              sHint: "Número de Teléfono",
              tecController: tecPhone,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: enviarTelefonoPressed,
              child: Text("Registrar"),
            ),
            SizedBox(height: 16.0),
            if (blMostrarVerificacion)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomPhoneTextField(
                    sHint: "Número de Verificación",
                    tecController: tecVerify,
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: enviarVerifyPressed,
                    child: Text("Establecer Código"),
                  ),
                ],
              ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: onClickCancelar,
              child: Text("Cancelar"),
            ),
          ],
        ),
      ),
    );
  }
}
