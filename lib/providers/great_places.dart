import 'dart:io';
import 'package:flutter/foundation.dart';
import '../helpers/db_helper.dart';
import '../models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  void addPlace(String pickedTitle, File pickedImage) {
    final newPlace = Place(
        id: DateTime.now().toString(),
        title: pickedTitle,
        location: null,
        image: pickedImage);
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert("user_places", {
      "id": newPlace.id,
      "title": newPlace.title,
      "image": newPlace.image.path
    } /*The keys in the map must match the fields in create table query in db helper   */);
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.fetch("user_places");
    _items = dataList
        .map((item) => Place(
            id: item["id"],
            title: item["title"],
            location: null,
            image: File(item["image"])))
        .toList();
    notifyListeners();
  }
}
