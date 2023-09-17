import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
class MapLoc extends StatefulWidget {
  final double lat,lng;
  const MapLoc({Key? key, required this.lat, required this.lng}) : super(key: key);

  @override
  State<MapLoc> createState() => _MapLocState();
}

class _MapLocState extends State<MapLoc> {
  @override
  Widget build(BuildContext context) {
    LatLng? loc=LatLng(widget.lat,widget.lng);
    return Scaffold(
      body: Center(
        child: Container(
          child: FlutterMap(
            options: MapOptions(
              center: loc,
              zoom: 9.2,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: [Marker(point: loc, builder: (ctx)=>Icon(Icons.location_pin,color: Colors.red,))],
              )
            ],

          ),
        ),
      ),
    );
  }
}
