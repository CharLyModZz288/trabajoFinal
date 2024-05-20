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

  final List<Map<String, dynamic>> locations = [
    {
      'title': 'Puerta del Sol',
      'position': LatLng(40.416775, -3.703790),
    },
    {
      'title': 'Plaza Mayor',
      'position': LatLng(40.41610297733032, -3.7072444022172397),
    },
    {
      'title': 'Parque del Retiro',
      'position': LatLng(40.423324, -3.705227),
    },
    {
      'title': 'Museo del Prado',
      'position': LatLng(40.41348901779781, -3.6923098631669085),
    },
    {
      'title': 'Gran Vía',
      'position': LatLng(40.419631661619235, -3.70119333898133),
    },
  ];

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
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kMadrid,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              agregarMarcadores();
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton.extended(
                onPressed: _showTransportOptions,
                label: Text('Opciones de ruta'),
                icon: Icon(Icons.directions),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void agregarMarcadores() {
    locations.forEach((location) {
      Marker marcador = Marker(
        markerId: MarkerId(location['title']),
        position: location['position'],
        infoWindow: InfoWindow(title: location['title']),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );

      setState(() {
        marcadores.add(marcador);
      });
    });
  }

  Future<void> _irADondeEstas(String mode, LatLng destino) async {
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

    await _obtenerRuta(destino, ubicacionUsuario, mode);
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
        _showEstimatedTimeDialog(mode, tiempoEstimado);
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

  void _showEstimatedTimeDialog(String mode, String tiempoEstimado) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tiempo estimado'),
          content: Text('${modeNames[mode]}, Tiempo estimado: $tiempoEstimado'),
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

  void _showDestinationOptions(String mode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Elige un destino'),
          content: SingleChildScrollView(
            child: ListBody(
              children: locations.map((location) {
                return ListTile(
                  title: Text(location['title']),
                  onTap: () {
                    Navigator.pop(context);  // Cerrar el diálogo de selección de destino
                    _irADondeEstas(mode, location['position']);  // Pasar la posición seleccionada
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _showTransportOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.25,
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
                  Navigator.pop(context);  // Cerrar el cuadro modal de opciones de transporte
                  _showDestinationOptions(mode);  // Mostrar el diálogo de selección de destino
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
