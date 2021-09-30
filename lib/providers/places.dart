import 'dart:io';

import 'package:flutter/cupertino.dart';
import '../models/place.dart';
import '../helpers/db_helper.dart';

class PlacesProvider with ChangeNotifier {
  List<Place> _places = [];

  List<Place> get places {
    return [..._places];
  }

  Future<void> fetchAndSetPlaces() async {
    final extractedData = await DBHelper.getData('user_places');

    _places = extractedData
        .map((place) => Place(
            id: place['id'],
            title: place['title'],
            image: File(place['image']),
            location: null))
        .toList();

    notifyListeners();
  }

  void addPlace({
    required String title,
    //required PlaceLocation location,
    required File image,
  }) {
    final newPlace = Place(
        id: DateTime.now().toString(),
        title: title,
        image: image,
        location: null);
    _places.add(newPlace);
    notifyListeners();

    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
    });
  }

  void deletePlace(String id) {
    _places.removeWhere((place) => place.id == id);
    notifyListeners();
    DBHelper.deleteRecord(id);
  }
}
