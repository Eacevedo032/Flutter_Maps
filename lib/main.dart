import 'package:flutter/material.dart';
import 'package:flutter_maps/menu_de_opciones.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(const FlutterMapsApp());

class FlutterMapsApp extends StatelessWidget {
  const FlutterMapsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Maps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FlutterMapsPage(),
    );
  }
}

class FlutterMapsPage extends StatefulWidget {
  const FlutterMapsPage({Key? key}) : super(key: key);

  @override
  _FlutterMapsPageState createState() => _FlutterMapsPageState();
}

class _FlutterMapsPageState extends State<FlutterMapsPage> {
  GoogleMapController? mapController;

  double latitude = 11.97444; // Valor inicial de latitud
  double longitude = -86.09417; // Valor inicial de longitud
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  Set<Marker> markers = {}; // Conjunto de marcadores en el mapa

  void searchLocation() {
    double lat = double.tryParse(latitudeController.text) ?? 0.0;
    double lng = double.tryParse(longitudeController.text) ?? 0.0;

    setState(() {
      latitude = lat;
      longitude = lng;
      markers.clear(); // Eliminar marcadores existentes
      markers.add(
        Marker(
          markerId: MarkerId("searchedLocation"),
          position: LatLng(latitude, longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed), // Marcador rojo
        ),
      );
    });

    // También puedes mover la cámara del mapa a la nueva ubicación utilizando el controlador del mapa
    mapController
        ?.animateCamera(CameraUpdate.newLatLng(LatLng(latitude, longitude)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Maps'),
      ),
      drawer: OptionsDrawer(),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: latitudeController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Latitud',
                  ),
                ),
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: TextField(
                  controller: longitudeController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Longitud',
                  ),
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: searchLocation,
            child: Text('Buscar'),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                setState(() {
                  mapController = controller;
                });
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(latitude, longitude),
                zoom: 12.0,
              ),
              markers: markers, // Agregar los marcadores al mapa
            ),
          ),
        ],
      ),
    );
  }
}
