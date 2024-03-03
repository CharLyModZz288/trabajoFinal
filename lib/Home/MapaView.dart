import 'dart:async';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Singletone/DataHolder.dart';

class MapaView extends StatefulWidget {
  @override
  State<MapaView> createState() => MapaViewState();
}

class MapaViewState extends State<MapaView> {
  late GoogleMapController _controller;
  Set<Marker> marcadores = Set();

  static final CameraPosition _kMadrid = CameraPosition(
    target: LatLng(40.4168, -3.7038), // Coordenadas de Madrid
    zoom: 14.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kMadrid,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        markers: marcadores,
        gestureRecognizers: Set()
          ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
          ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
          ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
          ..add(Factory<VerticalDragGestureRecognizer>(
                  () => VerticalDragGestureRecognizer())),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('Ir a donde estas'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    CameraPosition _kUser = CameraPosition(
      target: LatLng(40.421112921683, -3.567800203332735),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414,
    );

    _controller.animateCamera(CameraUpdate.newCameraPosition(_kUser));

    Marker marcador = Marker(
      markerId: MarkerId('1'),
      position: LatLng(40.4709546, -3.4700426),
    );

    setState(() {
      marcadores.add(marcador);
    });
  }
}