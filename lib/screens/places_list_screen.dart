import 'dart:io';

import 'package:flutter/material.dart';
import 'package:great_places_app/screens/add_new_place_screen.dart';
import 'package:great_places_app/screens/place_details_screen.dart';
import '../providers/places.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _isLoading = false;
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Consumer<PlacesProvider>(
              child: const Center(
                  child: Text(
                      'You don\'t have any places yet, start adding some!')),
              builder: (context, placesData, child) =>
                  (placesData.places.isEmpty)
                      ? child!
                      : ListView.separated(
                          padding: const EdgeInsets.all(8),
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: placesData.places.length,
                          itemBuilder: (context, index) => PlacesListItem(
                            title: placesData.places[index].title,
                            image: placesData.places[index].image,
                          ),
                        ),
            ),
    );
  }
}

class PlacesListItem extends StatelessWidget {
  final String? title;
  final File? image;

  PlacesListItem({
    this.title,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 35,
            backgroundImage: FileImage(image!),
          ),
          title: Container(
            width: 100,
            height: 35,
            child: FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.contain,
              child: Text(
                title!,
                style: const TextStyle(fontSize: 25),
              ),
            ),
          ),
          onTap: () {
            // Navigator.of(context).pushNamed(PlaceDetailsScreen.routeName);
          },
        ),
      ),
    );
  }
}
