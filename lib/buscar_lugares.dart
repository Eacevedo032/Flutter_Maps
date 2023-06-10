import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class buscar_lugares extends StatefulWidget {
  @override
  _EstadoBuscarLugares createState() => _EstadoBuscarLugares();
}

class _EstadoBuscarLugares extends State<buscar_lugares> {
  final TextEditingController _countryController = TextEditingController();
  GoogleMapController? _mapController;
  LatLng? _selectedLatLng;

  Future<void> _searchLocation() async {
    final String countryName = _countryController.text;

    try {
      List<Location> locations = await locationFromAddress(countryName);
      if (locations.isNotEmpty) {
        setState(() {
          final Location location = locations[0];
          _selectedLatLng = LatLng(
            location.latitude,
            location.longitude,
          );
        });
        _moveCameraToSelectedLocation();
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _moveCameraToSelectedLocation() {
    if (_selectedLatLng != null && _mapController != null) {
      final cameraUpdate = CameraUpdate.newLatLng(_selectedLatLng!);
      _mapController!.animateCamera(cameraUpdate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Busqueda por nombres'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _countryController,
              decoration: InputDecoration(
                labelText: 'Ingrese un nombre de Pais o ciudad',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _searchLocation,
            child: Text('Buscar'),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) {
                setState(() {
                  _mapController = controller;
                });
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(0, 0),
              ),
              markers: _selectedLatLng != null
                  ? {
                      Marker(
                        markerId: MarkerId('seleccionarubicacion'),
                        position: _selectedLatLng!,
                      ),
                    }
                  : {},
            ),
          ),
        ],
      ),
    );
  }
}
