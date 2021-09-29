import 'package:flutter/material.dart';
import 'package:great_places_app/providers/places.dart';
import 'package:great_places_app/screens/add_new_place_screen.dart';
import 'package:provider/provider.dart';
import './screens/places_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PlacesProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo)
              .copyWith(secondary: Colors.amber),
        ),
        home: const PlacesListScreen(),
        routes: {
          AddNewPlaceScreen.routeName: (context) => const AddNewPlaceScreen()
        },
      ),
    );
  }
}
