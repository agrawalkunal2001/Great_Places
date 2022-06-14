import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:great_places/helpers/location_helper.dart';
import '../helpers/db_helper.dart';
import '../models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Future<void> addPlace(String pickedTitle, File pickedImage,
      PlaceLocation pickedLocation) async {
    final address = await LocationHelper.getPlaceAddress(
        pickedLocation.latitude as double, pickedLocation.longitude as double);
    final updatedLocation = PlaceLocation(
        latitude: pickedLocation.latitude,
        longitude: pickedLocation.longitude,
        address: address);
    final newPlace = Place(
        id: DateTime.now().toString(),
        title: pickedTitle,
        location: updatedLocation,
        image: pickedImage);
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert("user_places", {
      "id": newPlace.id,
      "title": newPlace.title,
      "image": newPlace.image.path,
      "loc_lat": newPlace.location!.latitude as double,
      "loc_lng": newPlace.location!.longitude as double,
      "address": newPlace.location!.address as String,
    } /*The keys in the map must match the fields in create table query in db helper   */);
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.fetch("user_places");
    _items = dataList
        .map((item) => Place(
            id: item["id"],
            title: item["title"],
            location: PlaceLocation(
                latitude: item["loc_lat"],
                longitude: item["loc_lng"],
                address: item["address"]),
            image: File(item["image"])))
        .toList();
    notifyListeners();
  }
}
