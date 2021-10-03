import 'package:flutter/material.dart';
import 'package:great_places_app/screens/add_new_place_screen.dart';

import '../widgets/places_list_item.dart';
import '../providers/places.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatefulWidget {
  const PlacesListScreen({Key? key}) : super(key: key);

  @override
  State<PlacesListScreen> createState() => _PlacesListScreenState();
}

class _PlacesListScreenState extends State<PlacesListScreen> {
  Future? _placesFuture;

  Future _obtainPlacesFuture() {
    return Provider.of<PlacesProvider>(context, listen: false)
        .fetchAndSetPlaces();
  }

  @override
  void initState() {
    // TODO: implement initState
    _placesFuture = _obtainPlacesFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your places'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddNewPlaceScreen.routeName);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: _placesFuture,
        builder: (context, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error == null) {
              return Consumer<PlacesProvider>(
                child: const Center(
                    child: Text(
                        'You don\'t have any places yet, start adding some!')),
                builder: (context, placesData, child) => (placesData
                        .places.isEmpty)
                    ? child!
                    : ListView.separated(
                        padding: const EdgeInsets.all(8),
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: placesData.places.length,
                        itemBuilder: (context, index) => PlacesListItem(
                          id: placesData.places[index].id!,
                          title: placesData.places[index].title,
                          image: placesData.places[index].image,
                          address: placesData.places[index].location!.address,
                        ),
                      ),
              );
            } else {
              Future.delayed(Duration.zero).then((value) =>
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Something went wrong!'))));
              return const Center(
                child: Text('An Error Occurred!'),
              );
            }
          }
        },
      ),
    );
  }
}
