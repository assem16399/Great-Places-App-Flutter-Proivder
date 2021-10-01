import 'dart:io';

import 'package:flutter/material.dart';
import 'package:great_places_app/providers/places.dart';
import 'package:great_places_app/screens/place_details_screen.dart';
import 'package:provider/provider.dart';

class PlacesListItem extends StatelessWidget {
  final String? title;
  final File? image;
  final String id;

  PlacesListItem({
    required this.id,
    this.title,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(PlaceDetailsScreen.routeName);
      },
      child: Card(
        elevation: 2,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: SizedBox(
                width: double.infinity,
                height: deviceSize.height * 0.3,
                child: Image(
                  image: FileImage(image!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListTile(
              title: SizedBox(
                height: deviceSize.height * 0.05,
                child: FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: (title!.length <= 20) ? BoxFit.none : BoxFit.contain,
                  child: Text(
                    title!,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 20),
                  ),
                ),
              ),
              trailing: IconButton(
                onPressed: () {
                  Provider.of<PlacesProvider>(context, listen: false)
                      .deletePlace(id);
                },
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                  size: 25,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
