import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/models/place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isSelecting;

  MapScreen(
      {this.initialLocation =
          const PlaceLocation(latitude: 20.273388, longitude: 72.994050),
      this.isSelecting = false});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select  Location"),
      ),
      body: GoogleMap(
        // It assumes the height and width of the parent widget
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialLocation.latitude as double,
            widget.initialLocation.longitude as double,
          ),
          zoom: 16,
        ),
      ),
    );
  }
}
