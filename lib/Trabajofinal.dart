
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trabajofinal/Home/AjustesView.dart';
import 'package:trabajofinal/Home/HomeView2.dart';
import 'package:trabajofinal/onBoarding/PhoneLoginView.dart';
import 'package:trabajofinal/splash/SplashView.dart';

import 'Home/EditarPost.dart';
import 'Home/Editarperfil.dart';
import 'Home/HomeView.dart';
import 'Home/HomeView3.dart';
import 'Home/HomeView4.dart';
import 'Home/MapaView.dart';
import 'Home/PostCreateView.dart';
import 'Home/PostCreateView2.dart';
import 'Home/PostCreateView3.dart';
import 'Home/PostCreateView4.dart';
import 'Singletone/DataHolder.dart';
import 'onBoarding/LoginView.dart';
import 'onBoarding/PerfilView.dart';
import 'onBoarding/RegisterView.dart';

class MuseoYismer extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    MaterialApp materialApp;
    DataHolder().initPlatformAdmin(context);
    materialApp=MaterialApp(title: "MUSEO YISMER",
      routes: {
        '/splashview':(context) => SplashView(),
        '/loginview':(context) => LoginView(),
        '/phoneloginview':(context) => PhoneLoginView(),
        '/registerview':(context) => RegisterView(),
        '/perfilview':(context) => PerfilView(),
        '/homeview':(context) => HomeView(),
        '/homeview2':(context) => HomeView2(),
        '/homeview3':(context) => HomeView3(),
        '/homeview4':(context) => HomeView4(),
        '/postcreateview':(context) => PostCreateView(),
        '/postcreateview2':(context) => PostCreateView2(),
        '/postcreateview3':(context) => PostCreateView3(),
        '/postcreateview4':(context) => PostCreateView4(),
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