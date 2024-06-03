import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../CustomViews/CustomCellView.dart';
import '../CustomViews/CustomDrawer.dart';
import '../CustomViews/CustomGredCellView.dart';
import '../FirebaseObjects/FbPostId.dart';
import '../FirebaseObjects/FbUsuario.dart';
import '../Singletone/DataHolder.dart';
import '../onBoarding/LoginView.dart';
import 'ThemeNotifier.dart';

class HomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeViewState();
  }
}

class _HomeViewState extends State<HomeView> {
  TextEditingController bdUsuarioNombre = TextEditingController();
  TextEditingController bdUsuarioEdad = TextEditingController();

  FirebaseFirestore db = FirebaseFirestore.instance;
  DataHolder dataHolder = DataHolder();
  late FbUsuario perfil;
  bool bIsList = false;
  final Map<String, FbPostId> mapPosts = Map();
  final List<FbPostId> posts = [];
  final List<FbUsuario> listaUsuarios = [];
  late Future<FbUsuario> _futurePerfil;
  late String imagenurl;

  Map<String, dynamic> miDiccionario = {};

  @override
  void initState() {
    super.initState();
    conseguirUsuario();
    descargarPosts();
    loadGeoLocator();
  }

  void loadGeoLocator() async {
    Position pos = await DataHolder().geolocAdmin.determinePosition();
    print("------------>>>> " + pos.toString());
    DataHolder().geolocAdmin.registrarCambiosLoc();
  }

  void descargarPosts() async {
    posts.clear();

    CollectionReference<FbPostId> postsRef = db.collection("PostUsuario").withConverter(
      fromFirestore: FbPostId.fromFirestore,
      toFirestore: (FbPostId post, _) => post.toFirestore(),
    );

    postsRef.snapshots().listen(
      datosDescargados,
      onError: descargaPostError,
    );
  }

  void datosDescargados(QuerySnapshot<FbPostId> postsdescargados) {
    print("NUMERO DE POSTS ACTUALIZADOS>>>> " + postsdescargados.docChanges.length.toString());

    for (int i = 0; i < postsdescargados.docChanges.length; i++) {
      FbPostId temp = postsdescargados.docChanges[i].doc.data()!;
      mapPosts[postsdescargados.docChanges[i].doc.id] = temp;
    }
    setState(() {
      posts.clear();
      posts.addAll(mapPosts.values);
    });
  }

  void descargaPostError(error) {
    print("Listen failed: $error");
  }

  void uploadImageToFirebase(File imageFile) async {
    if (imageFile != null) {
      Reference storageReference = FirebaseStorage.instance.ref().child('user_profile_images/${DateTime.now()}.png');

      UploadTask uploadTask = storageReference.putFile(imageFile);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        print('Progreso: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100}%');
      });

      await uploadTask.whenComplete(() {
        print('Carga completada');
      });
      String downloadURL = await storageReference.getDownloadURL();
    }
  }

  void conseguirUsuario() async {
    FbUsuario perfil = await dataHolder.fbadmin.conseguirUsuario();
    setState(() {
      this.perfil = perfil;
    });
  }

  void onItemListClicked(int index) {
    DataHolder().selectedPost = posts[index];

    Navigator.of(context).pushNamed("/usuarioview");
  }

  void onBottonMenuPressed(int indice) {
    setState(() {
      switch (indice) {
        case 0:
          descargarPosts();
          if (posts.isEmpty) {
            print("Lista vacia");
          }
          bIsList = true;
          break;
        case 1:
          bIsList = false;
          break;
        case 2:
          exit(0);
        case 3:
          Navigator.of(context).pushNamed("/usuarioview");
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool isDarkMode = themeNotifier.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("Publicaciones"),
        backgroundColor: Colors.amarillotrabajo,
        actions: [
          IconButton(
            icon: Icon(Icons.poll),
            onPressed: () {
              Navigator.of(context).pushNamed("/encuestasview");
            },
          ),
          IconButton(
            icon: Icon(Icons.lightbulb), // Icono para cambiar el tema
            onPressed: () {
              print("11111111111");
              final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
              if (themeNotifier.themeMode == ThemeMode.light) {
                print("222222");
                themeNotifier.setTheme(ThemeMode.dark);
              } else {
                print("33333333");
                themeNotifier.setTheme(ThemeMode.light);
              }
            },
          ),
        ],
      ),

      backgroundColor: Colors.grey[400],
      body: Center(
        child: celdasOLista(bIsList),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.list),
              onPressed: () {
                setState(() {
                  bIsList = true;
                });
              },
            ),
            FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/postcreateview");
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.amarillotrabajo,
              elevation: 0,
            ),
            IconButton(
              icon: Icon(Icons.grid_view),
              onPressed: () {
                setState(() {
                  bIsList = false;
                });
              },
            ),
          ],
        ),
      ),
      drawer: CustomDrawer(
        onItemTap: fHomeViewDrawerOnTap,
        imagen: perfil.shint,
      ),
    );
  }

  String recorrerDiccionario(Map diccionario) {
    String valores = '';

    for (String p in diccionario.keys) {
      dynamic valor = diccionario[p];
      valores += p + " : " + valor.toString() + " ";
    }
    return valores;
  }

  void fHomeViewDrawerOnTap(int indice) async {
    print("---->>>> " + indice.toString());

    if (indice == 1) {
      FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => LoginView()),
        ModalRoute.withName('/loginview'),
      );
    } else if (indice == 0) {
      Navigator.of(context).pushNamed(
        '/editarperfil',
        arguments: {},
      );
    } else if (indice == 3) {
      TextEditingController _searchController = TextEditingController();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Buscar Post por Título'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Qué título deseas buscar',
                    contentPadding: EdgeInsets.all(16.0),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    String searchValue = _searchController.text.trim();
                    if (searchValue.isNotEmpty) {
                      Navigator.of(context).pop(); // Cerrar el diálogo de búsqueda

                      List<Map<String, dynamic>> searchResults = await DataHolder().fbadmin.searchPostsByTitle(searchValue);

                      if (searchResults.isNotEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Resultados de la Búsqueda'),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  for (var result in searchResults)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('ID del Post: ${result['Idpost']}'),
                                        Text('Título: ${result['Titulo']}'),
                                        Text('Usuario: ${result['Usuario']}'),
                                      ],
                                    ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  child: Text('Aceptar'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Resultados de la Búsqueda'),
                              content: Text('No hay búsquedas relacionadas con tu petición.'),
                              actions: [
                                TextButton(
                                  child: Text('Aceptar'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                  child: Text('Buscar'),
                ),
              ],
            ),
          );
        },
      );
    } else if (indice == 2) {
      Navigator.of(context).pushNamed('/mapaview');
    } else if (indice == 4) {
      Navigator.of(context).pushNamed('/ajustesview');
    } else if (indice == 5) {
      Navigator.of(context).pushNamed('/homeview2');
    } else if (indice == 6) {
      Navigator.of(context).pushNamed('/homeview3');
    } else if (indice == 7) {
      Navigator.of(context).pushNamed('/homeview4');
    } else if (indice == 8) {
      Navigator.of(context).pushNamed('/favoritesview');
    } else if (indice == 9) {
      Navigator.of(context).pushNamed('/myphotosview');
    }
  }

  Widget? creadorDeItemLista(BuildContext context, int index) {
    return CustomCellView(
      sTexto: recorrerDiccionario(miDiccionario) + " " + posts[index].post,
      iCodigoColor: 50,
      dFuenteTamanyo: 20,
      iPosicion: index,
      imagen: posts[index].sUrlImg,
      onItemListClickedFun: onItemListClicked,
      tituloPost: posts[index].titulo,
      usuario: posts[index].usuario,
      idPost: posts[index].id,
      contenido: posts[index].post,
    );
  }

  Widget? creadorDeItemMatriz(BuildContext context, int index) {
    return CustomGredCellView(
      sText: posts[index].post,
      dFontSize: 20,
      imagen: posts[index].sUrlImg,
      iColorCode: 0,
      usuario: posts[index].usuario,
      tituloPost: posts[index].titulo,
      contenido: posts[index].post,
      idPost: posts[index].id,
    );
  }

  Widget creadorDeSeparadorLista(BuildContext context, int index) {
    return Column(
      children: [
        Divider(),
      ],
    );
  }

  Widget celdasOLista(bool isList) {
    if (isList) {
      return ListView.separated(
        padding: EdgeInsets.all(8),
        itemCount: posts.length,
        itemBuilder: creadorDeItemLista,
        separatorBuilder: creadorDeSeparadorLista,
      );
    } else {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemCount: posts.length,
        itemBuilder: creadorDeItemMatriz,
      );
    }
  }
}
