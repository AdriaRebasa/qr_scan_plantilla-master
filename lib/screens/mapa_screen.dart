import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qr_scan/models/scan_model.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({Key? key}) : super(key: key);

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  MapType _mapType = MapType.normal;
  late CameraPosition _puntoInicial;

  @override
  Widget build(BuildContext context) {
    final ScanModel scan =
        ModalRoute.of(context)!.settings.arguments as ScanModel;

    _puntoInicial = CameraPosition(
      target: scan.getLatLng(),
      zoom: 17,
    );

    final Set<Marker> markers = {
      Marker(
        markerId: const MarkerId('geo-location'),
        position: scan.getLatLng(),
      )
    };

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapType: _mapType,
            markers: markers,
            initialCameraPosition: _puntoInicial,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),

          // 🔙 Botó tornar enrere (adalt esquerra)
          Positioned(
            top: 40,
            left: 10,
            child: FloatingActionButton(
              heroTag: 'back',
              backgroundColor: Colors.white,
              child: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'home');
              },
            ),
          ),

          // 🎯 Botó centrar càmera (adalt dreta)
          Positioned(
            top: 40,
            right: 10,
            child: FloatingActionButton(
              heroTag: 'center',
              child: const Icon(Icons.my_location),
              onPressed: () async {
                final controller = await _controller.future;
                controller.animateCamera(
                  CameraUpdate.newCameraPosition(_puntoInicial),
                );
              },
            ),
          ),

          // 🗺️ Botó canviar tipus de mapa (abaix esquerra)
          Positioned(
            bottom: 20,
            left: 10,
            child: FloatingActionButton(
              heroTag: 'mapType',
              child: const Icon(Icons.layers),
              onPressed: () {
                setState(() {
                  _mapType = _mapType == MapType.normal
                      ? MapType.satellite
                      : MapType.normal;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
