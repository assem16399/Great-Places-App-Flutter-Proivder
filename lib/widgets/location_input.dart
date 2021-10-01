import 'package:flutter/material.dart';
import 'package:great_places_app/helpers/location_helper.dart';
import 'package:great_places_app/screens/maps_screen.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({Key? key}) : super(key: key);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  void _getUserLocation() async {
    final locationData = await Location().getLocation();
    print(locationData.latitude);
    print(locationData.longitude);

    setState(() {
      _previewImageUrl = LocationHelper.generateLocationPreviewImage(
          latitude: locationData.latitude, longitude: locationData.longitude);
    });
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
              onPressed: _getUserLocation,
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
              onPressed: () {
                Navigator.of(context).pushNamed(MapScreen.routeName);
              },
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
