import 'package:flutter/material.dart';

class PlaceDetailsScreen extends StatelessWidget {
  static const routeName = '/please-details';
  const PlaceDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
    );
  }
}
