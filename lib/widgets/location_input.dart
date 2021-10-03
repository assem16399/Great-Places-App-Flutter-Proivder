import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places_app/helpers/location_helper.dart';
import 'package:great_places_app/models/place.dart';
import 'package:great_places_app/screens/maps_screen.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final Function onLocationSelect;
  const LocationInput(this.onLocationSelect);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  void _showStaticMapPreview(double lat, double lng) {
    setState(() {
      _previewImageUrl = LocationHelper.generateLocationPreviewImage(
          latitude: lat, longitude: lng);
    });
  }

  void _getUserCurrentLocation() async {
    try {
      final locationData = await Location().getLocation();
      _showStaticMapPreview(locationData.latitude!, locationData.longitude!);
      widget.onLocationSelect(locationData.latitude, locationData.longitude);
    } catch (_) {
      return;
    }
  }

  void _selectOnMapScreen() async {
    final userCurrentLocation = await Location().getLocation();
    final selectedLocation = await Navigator.of(context).push<LatLng?>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => MapScreen(
          initialPlaceLocation: PlaceLocation(
              latitude: userCurrentLocation.latitude!,
              longitude: userCurrentLocation.longitude!),
          isSelecting: true,
        ),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    // the location that the user picked
    _showStaticMapPreview(
        selectedLocation.latitude, selectedLocation.longitude);

    widget.onLocationSelect(
        selectedLocation.latitude, selectedLocation.longitude);
  }

  String? _previewImageUrl;
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final _isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
          alignment: _previewImageUrl == null ? Alignment.center : null,
          height:
              _isLandscape ? deviceSize.height * 0.5 : deviceSize.height * 0.35,
          width: _isLandscape ? deviceSize.width * 0.51 : double.infinity,
          child: _previewImageUrl == null
              ? const Text('No Location Chosen')
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.fitHeight,
                  width: double.infinity,
                ),
        ),
        if (!_isLandscape)
          SizedBox(
            height: deviceSize.height * 0.02,
          ),
        Row(
          mainAxisAlignment: _isLandscape
              ? MainAxisAlignment.center
              : MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
              onPressed: _getUserCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: Text(
                'Current Location',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
            SizedBox(
              width: deviceSize.width * 0.015,
            ),
            ElevatedButton.icon(
              onPressed: _selectOnMapScreen,
              icon: const Icon(Icons.map),
              label: Text('Chose From The Map',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary)),
            )
          ],
        )
      ],
    );
  }
}
