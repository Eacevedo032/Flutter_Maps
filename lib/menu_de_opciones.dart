import 'package:flutter/material.dart';
import 'package:flutter_maps/ubicacion_actual.dart';
import 'package:flutter_maps/buscar_lugares.dart';

class OptionsDrawer extends StatelessWidget {
  const OptionsDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Text('Opciones'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Buscar lugares'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => buscar_lugares()),
              ); // Acción para la opción 1
            },
          ),
          ListTile(
            title: Text('Ubicación actual'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UbicacionActual()),
              );
              // Acción para la opción 2
            },
          )
        ],
      ),
    );
  }
}
