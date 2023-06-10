import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class UbicacionActual extends StatefulWidget {
  @override
  _UbicacionActualState createState() => _UbicacionActualState();
}

class _UbicacionActualState extends State<UbicacionActual> {
  Position? currentPosition;
  GoogleMapController? mapController;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    obtenerUbicacionActual();
  }

  Future<void> obtenerUbicacionActual() async {
    bool servicioHabilitado;
    PermissionStatus permissionStatus;

    servicioHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicioHabilitado) {
      throw Exception('Los servicios de ubicación están desactivados.');
    }

    permissionStatus = await Permission.locationWhenInUse.status;
    if (permissionStatus.isDenied) {
      permissionStatus = await Permission.locationWhenInUse.request();
      if (permissionStatus.isDenied) {
        throw Exception('Se han denegado los permisos de ubicación.');
      }
    }

    if (permissionStatus.isPermanentlyDenied) {
      throw Exception(
          'Se han denegado permanentemente los permisos de ubicación.');
    }

    try {
      currentPosition = await Geolocator.getCurrentPosition();
      setState(() {
        markers.clear();
        markers.add(
          Marker(
            markerId: MarkerId("ubicacionactual"),
            position: LatLng(
              currentPosition?.latitude ?? 0.0,
              currentPosition?.longitude ?? 0.0,
            ),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
        );
      });
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(
            currentPosition?.latitude ?? 0.0,
            currentPosition?.longitude ?? 0.0,
          ),
          15.0,
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ubicación actual'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) {
                mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  currentPosition?.latitude ?? 0.0,
                  currentPosition?.longitude ?? 0.0,
                ),
                zoom: 15.0,
              ),
              markers: markers,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              compassEnabled: false,
            ),
          ),
          if (currentPosition != null)
            Text(
              'Latitud: ${currentPosition!.latitude}\nLongitud: ${currentPosition!.longitude}',
              textAlign: TextAlign.center,
            )
          else
            Text('Obteniendo ubicación actual...'),
        ],
      ),
    );
  }
}
