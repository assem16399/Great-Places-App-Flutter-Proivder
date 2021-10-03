import 'dart:io';

import 'package:flutter/cupertino.dart';
import '../helpers/location_helper.dart';
import '../models/place.dart';
import '../helpers/db_helper.dart';

class PlacesProvider with ChangeNotifier {
  List<Place> _places = [];

  List<Place> get places {
    return [..._places];
  }

  Place findPlaceById(String id) {
    return _places.firstWhere((place) => place.id == id);
  }

  Future<void> fetchAndSetPlaces() async {
    final extractedData = await DBHelper.getData('user_places');

    _places = extractedData
        .map((place) => Place(
              id: place['id'],
              title: place['title'],
              image: File(place['image']),
              location: PlaceLocation(
                  latitude: place['location_lat'],
                  longitude: place['location_lng'],
                  address: place['location_address']),
            ))
        .toList();

    notifyListeners();
  }

  Future<void> addPlace({
    required String title,
    required PlaceLocation location,
    required File image,
  }) async {
    try {
      final readableAddress = await LocationHelper.getPlaceAddress(
          location.latitude, location.longitude);
      final loc = PlaceLocation(
          latitude: location.latitude,
          longitude: location.longitude,
          address: readableAddress);
      final newPlace = Place(
          id: DateTime.now().toString(),
          title: title,
          image: image,
          location: loc);
      _places.add(newPlace);
      notifyListeners();

      DBHelper.insert('user_places', {
        'id': newPlace.id,
        'title': newPlace.title,
        'image': newPlace.image.path,
        'location_lat': newPlace.location!.latitude,
        'location_lng': newPlace.location!.longitude,
        'location_address': newPlace.location!.address,
      });
    } catch (error) {
      rethrow;
    }
  }

  void deletePlace(String id) {
    _places.removeWhere((place) => place.id == id);
    notifyListeners();
    DBHelper.deleteRecord(id);
  }
}
