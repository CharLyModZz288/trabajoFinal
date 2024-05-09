import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapaView extends StatefulWidget {
  @override
  State<MapaView> createState() => MapaViewState();
}

class MapaViewState extends State<MapaView> {
  late GoogleMapController _controller;
  Set<Marker> marcadores = Set();

  // Posición inicial de Madrid
  static final CameraPosition _kMadrid = CameraPosition(
    target: LatLng(40.4168, -3.7038), // Coordenadas de Madrid
    zoom: 14.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kMadrid,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
          // Agregar el marcador en la posición inicial del mapa
          agregarMarcadorInicial();
        },
        markers: marcadores,
        gestureRecognizers: {
          Factory<PanGestureRecognizer>(() => PanGestureRecognizer()),
          Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
          Factory<TapGestureRecognizer>(() => TapGestureRecognizer()),
          Factory<VerticalDragGestureRecognizer>(
                  () => VerticalDragGestureRecognizer()),
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _irADondeEstas,
        label: Text('Ir a donde estás'),
        icon: Icon(Icons.location_on),
      ),
    );
  }

  void agregarMarcadorInicial() {
    // Crear un marcador en la posición inicial (Madrid)
    Marker marcadorInicial = Marker(
      markerId: MarkerId('inicial'),
      position: _kMadrid.target,
      infoWindow: InfoWindow(title: 'Madrid'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    // Agregar el marcador a la colección de marcadores
    setState(() {
      marcadores.add(marcadorInicial);
    });
  }

  Future<void> _irADondeEstas() async {
    // Coordenadas de la ubicación donde quieres agregar el marcador
    LatLng ubicacionUsuario = LatLng(40.421112921683, -3.567800203332735);

    // Configura la cámara para enfocarse en la nueva ubicación
    CameraPosition posicionCamera = CameraPosition(
      target: ubicacionUsuario,
      zoom: 19.0,
      tilt: 50.0,
    );

    // Anima la cámara para que se desplace a la nueva posición
    await _controller.animateCamera(CameraUpdate.newCameraPosition(posicionCamera));

    // Agregar el marcador a la posición deseada
    Marker marcador = Marker(
      markerId: MarkerId('ubicacionUsuario'),
      position: ubicacionUsuario,
      infoWindow: InfoWindow(title: 'Ubicación del usuario'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );

    // Agregar el marcador a la colección de marcadores
    setState(() {
      marcadores.add(marcador);
    });
  }
}
