import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

import 'Trabajofinal.dart';
import 'firebase_options.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Trabajofinal trabajofinal=Trabajofinal();
  runApp(trabajofinal);
}