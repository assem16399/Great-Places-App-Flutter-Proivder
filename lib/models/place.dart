import 'dart:io';

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String? address;

  PlaceLocation({
    required this.latitude,
    required this.longitude,
    this.address,
  });
}

class Place {
  final String? id;
  final String title;
  final PlaceLocation? location;
  final File image;
  Place({
    required this.id,
    required this.title,
    required this.location,
    required this.image,
  });

  Place copyWith({
    String? id,
    String? title,
    PlaceLocation? location,
    File? image,
  }) {
    return Place(
      id: id ?? this.id,
      title: title ?? this.title,
      location: location ?? this.location,
      image: image ?? this.image,
    );
  }
}
