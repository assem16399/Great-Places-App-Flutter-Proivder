import 'package:flutter/material.dart';
import 'package:great_places_app/models/place.dart';
import '../providers/places.dart';
import '../screens/maps_screen.dart';
import 'package:provider/provider.dart';

class PlaceDetailsScreen extends StatelessWidget {
  static const routeName = '/please-details';
  const PlaceDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final placeId = ModalRoute.of(context)!.settings.arguments as String;
    final place = Provider.of<PlacesProvider>(context, listen: false)
        .findPlaceById(placeId);
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: deviceSize.height * 0.3,
              child: Image(
                image: FileImage(place.image),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: deviceSize.height * 0.03,
            ),
            Text(
              place.location!.address!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, color: Colors.grey),
            ),
            SizedBox(
              height: deviceSize.height * 0.03,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.secondary)),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => MapScreen(
                          initialPlaceLocation: PlaceLocation(
                              latitude: place.location!.latitude,
                              longitude: place.location!.longitude,
                              address: place.location!.address),
                        )));
              },
              child: const Text('View Location On Map'),
            )
          ],
        ),
      ),
    );
  }
}
