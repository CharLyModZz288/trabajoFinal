import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapaView extends StatefulWidget {
  @override
  State<MapaView> createState() => MapaViewState();
}

class MapaViewState extends State<MapaView> {
  late GoogleMapController _controller;
  Set<Marker> marcadores = Set();
  Set<Polyline> polylines = Set();
  List<String> transportModes = ['driving', 'walking', 'transit'];
  Map<String, String> modeNames = {
    'driving': 'Coche',
    'walking': 'Andando',
    'transit': 'Transporte Público'
  };

  static final CameraPosition _kMadrid = CameraPosition(
    target: LatLng(40.4168, -3.7038),
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
          agregarMarcadorInicial();
        },
        markers: marcadores,
        polylines: polylines,
        gestureRecognizers: {
          Factory<PanGestureRecognizer>(() => PanGestureRecognizer()),
          Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
          Factory<TapGestureRecognizer>(() => TapGestureRecognizer()),
          Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer()),
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showTransportOptions,
        label: Text('Opciones de ruta'),
        icon: Icon(Icons.directions),
      ),
    );
  }

  void agregarMarcadorInicial() {
    Marker marcadorInicial = Marker(
      markerId: MarkerId('inicial'),
      position: _kMadrid.target,
      infoWindow: InfoWindow(title: 'Madrid'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      marcadores.add(marcadorInicial);
    });
  }

  Future<void> _irADondeEstas(String mode) async {
    LatLng ubicacionUsuario = LatLng(40.421112921683, -3.567800203332735);

    CameraPosition posicionCamera = CameraPosition(
      target: ubicacionUsuario,
      zoom: 19.0,
      tilt: 50.0,
    );

    await _controller.animateCamera(CameraUpdate.newCameraPosition(posicionCamera));

    Marker marcador = Marker(
      markerId: MarkerId('ubicacionUsuario'),
      position: ubicacionUsuario,
      infoWindow: InfoWindow(title: 'Ubicación del usuario'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );

    setState(() {
      marcadores.add(marcador);
    });

    await _obtenerRuta(_kMadrid.target, ubicacionUsuario, mode);
  }

  Future<void> _obtenerRuta(LatLng inicio, LatLng fin, String mode) async {
    String apiKey = 'AIzaSyAuyAS_-U49zDg7Lr2FRqM0XBPrzNMLsA4'; // Asegúrate de que la clave sea correcta
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${inicio.latitude},${inicio.longitude}&destination=${fin.latitude},${fin.longitude}&mode=$mode&key=$apiKey';

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);

      if (json['status'] == 'OK') {
        var ruta = json['routes'][0];
        var puntosCodificados = ruta['overview_polyline']['points'];
        var puntos = _decodePoly(puntosCodificados);

        setState(() {
          polylines.clear(); // Limpiamos las polylíneas antes de agregar una nueva
          polylines.add(Polyline(
            polylineId: PolylineId(mode),
            points: puntos,
            color: mode == 'driving'
                ? Colors.blue
                : mode == 'walking'
                ? Colors.green
                : Colors.red,
            width: 5,
          ));
        });

        var tiempoEstimado = ruta['legs'][0]['duration']['text'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Modo: ${modeNames[mode]}, Tiempo estimado: $tiempoEstimado'),
          ),
        );
      } else {
        print('Error en la respuesta de la API de Direcciones: ${json['status']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al obtener la ruta: ${json['status']}'),
          ),
        );
      }
    } else {
      print('Error en la solicitud HTTP: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error en la solicitud HTTP: ${response.statusCode}'),
        ),
      );
    }
  }

  List<LatLng> _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = <int>[];
    list.forEach(lList.add);
    var len = poly.length;
    var index = 0;
    var lat = 0;
    var lng = 0;
    var points = <LatLng>[];

    while (index < len) {
      var b;
      var shift = 0;
      var result = 0;

      do {
        b = lList[index] - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
        index++;
      } while (b >= 0x20);
      var dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = lList[index] - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
        index++;
      } while (b >= 0x20);
      var dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  void _showTransportOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          child: Column(
            children: transportModes.map((mode) {
              return ListTile(
                leading: Icon(
                  mode == 'driving'
                      ? Icons.directions_car
                      : mode == 'walking'
                      ? Icons.directions_walk
                      : Icons.directions_transit,
                ),
                title: Text(modeNames[mode]!),
                onTap: () {
                  Navigator.pop(context);
                  _irADondeEstas(mode);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
