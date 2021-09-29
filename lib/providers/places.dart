import 'dart:io';

import 'package:flutter/cupertino.dart';
import '../models/place.dart';

class PlacesProvider with ChangeNotifier {
  List<Place> _places = [];

  List<Place> get places {
    return [..._places];
  }

  void addPlace({
    required String title,
    //required PlaceLocation location,
    required File image,
  }) {
    _places.add(Place(
        id: DateTime.now().toString(),
        title: title,
        image: image,
        location: null));
    notifyListeners();
  }
}
