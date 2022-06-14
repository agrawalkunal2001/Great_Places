import 'package:flutter/material.dart';
import 'package:great_places/helpers/location_helper.dart';
import 'package:great_places/screens/map_screen.dart';
import 'dart:io';
import 'package:location/location.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class LocationInput extends StatefulWidget {
  const LocationInput({Key? key}) : super(key: key);

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

  Future<void> _getUserCurrentLocation() async {
    final locationData = await Location().getLocation();
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
        latitude: locationData.latitude, longitude: locationData.longitude);
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
              isSelecting: true,
            )));
    if (selectedLocation == null) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: _previewImageUrl == null
              ? Text(
                  "No Location Chosen!",
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl as String,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton.icon(
                icon: Icon(Icons.location_on),
                label: Text("Current Location"),
                textColor: Theme.of(context).primaryColor,
                onPressed: _getUserCurrentLocation),
            FlatButton.icon(
                icon: Icon(Icons.map),
                label: Text("Select on Map"),
                textColor: Theme.of(context).primaryColor,
                onPressed: _selectOnMap),
          ],
        ),
      ],
    );
  }
}
