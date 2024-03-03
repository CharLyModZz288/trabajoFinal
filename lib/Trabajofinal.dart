
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trabajofinal/Home/AjustesView.dart';
import 'package:trabajofinal/splash/SplashView.dart';

import 'Home/EditarPost.dart';
import 'Home/Editarperfil.dart';
import 'Home/HomeView.dart';
import 'Home/MapaView.dart';
import 'Home/PostCreateView.dart';
import 'Singletone/DataHolder.dart';
import 'onBoarding/LoginView.dart';
import 'onBoarding/PerfilView.dart';
import 'onBoarding/RegisterView.dart';

class Trabajofinal extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    MaterialApp materialApp;
    DataHolder().initPlatformAdmin(context);
    materialApp=MaterialApp(title: "TrabajoFinal",
      routes: {
        '/splashview':(context) => SplashView(),
        '/loginview':(context) => LoginView(),
        '/registerview':(context) => RegisterView(),
        '/perfilview':(context) => PerfilView(),
        '/homeview':(context) => HomeView(),
        '/postcreateview':(context) => PostCreateView(),
        '/editarpost':(context) => EditarPost(),
        '/mapaview':(context) => MapaView(),
        '/editarperfil':(context) => Editarperfil(),
        '/ajustesview':(context) => AjustesView(),
      },
      initialRoute: '/splashview',
    );

    return materialApp;
  }

}