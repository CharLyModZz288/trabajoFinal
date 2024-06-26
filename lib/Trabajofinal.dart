import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trabajofinal/Home/AjustesView.dart';
import 'package:trabajofinal/Home/FavoritesView.dart';
import 'package:trabajofinal/Home/HomeAdmin.dart';
import 'package:trabajofinal/Home/HomeView2.dart';
import 'package:trabajofinal/Home/StreamersAdmin.dart';
import 'package:trabajofinal/Home/YoutubersAdmin.dart';
import 'package:trabajofinal/Home/EditarPost.dart';
import 'package:trabajofinal/Home/Editarperfil.dart';
import 'package:trabajofinal/Home/HomeView.dart';
import 'package:trabajofinal/Home/HomeView3.dart';
import 'package:trabajofinal/Home/HomeView4.dart';
import 'package:trabajofinal/Home/InfluencersAdmin.dart';
import 'package:trabajofinal/Home/MapaView.dart';
import 'package:trabajofinal/Home/PostCreateView.dart';
import 'package:trabajofinal/Home/PostCreateView2.dart';
import 'package:trabajofinal/Home/PostCreateView3.dart';
import 'package:trabajofinal/Home/PostCreateView4.dart';
import 'package:trabajofinal/Home/myPhotosview.dart';
import 'package:trabajofinal/Singletone/DataHolder.dart';
import 'package:trabajofinal/onBoarding/LoginView.dart';
import 'package:trabajofinal/onBoarding/PerfilView.dart';
import 'package:trabajofinal/onBoarding/PhoneLoginView.dart';
import 'package:trabajofinal/onBoarding/RegisterView.dart';
import 'package:trabajofinal/splash/SplashView.dart';
import 'package:trabajofinal/splash/SplashViewWeb.dart';

import 'Home/ThemeNotifier.dart';
import 'Home/encuestasview.dart';


class MuseoYismer extends StatefulWidget {
  @override
  _MuseoYismerState createState() => _MuseoYismerState();
}


class _MuseoYismerState extends State<MuseoYismer> {
  late MaterialApp materialApp;


  @override
  Widget build(BuildContext context) {
    DataHolder().initPlatformAdmin(context);

    // Rutas comunes para ambas plataformas.
    Map<String, WidgetBuilder> rutasComunes = {
      '/splashview': (context) => SplashView(),
      '/encuestasview': (context) => EncuestasView(),
      '/loginview': (context) => LoginView(),
      '/phoneloginview': (context) => PhoneLoginView(),
      '/registerview': (context) => RegisterView(),
      '/perfilview': (context) => PerfilView(),
      '/homeview': (context) => HomeView(),
      '/homeview2': (context) => HomeView2(),
      '/homeview3': (context) => HomeView3(),
      '/homeview4': (context) => HomeView4(),
      '/postcreateview': (context) => PostCreateView(),
      '/postcreateview2': (context) => PostCreateView2(),
      '/postcreateview3': (context) => PostCreateView3(),
      '/postcreateview4': (context) => PostCreateView4(),
      '/editarpost': (context) => EditarPost(),
      '/mapaview': (context) => MapaView(),
      '/editarperfil': (context) => Editarperfil(),
      '/ajustesview': (context) => AjustesView(),
      '/homeadmin': (context) => HomeAdmin(),
      '/youtubersadmin': (context) => YoutubersAdmin(),
      '/influencersadmin': (context) => InfluencersAdmin(),
      '/streamersadmin': (context) => StreamersAdmin(),
      '/favoritesview': (context) => FavoritesView(),
      '/myphotosview': (context) => MyPhotosView(),
    };

    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: "MUSEO YISMER",
          initialRoute: '/splashview',
          routes: rutasComunes,
          theme:themeNotifier.themeData,
        );
      },
    );
  }
}
