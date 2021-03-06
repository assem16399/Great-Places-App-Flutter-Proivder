import 'dart:io';

import 'package:flutter/material.dart';
import 'package:great_places_app/models/place.dart';
import '../widgets/location_input.dart';
import '../providers/places.dart';
import 'package:provider/provider.dart';
import '../widgets/image_input.dart';

class AddNewPlaceScreen extends StatefulWidget {
  const AddNewPlaceScreen({Key? key}) : super(key: key);
  static const routeName = '/add-new-place';

  @override
  State<AddNewPlaceScreen> createState() => _AddNewPlaceScreenState();
}

class _AddNewPlaceScreenState extends State<AddNewPlaceScreen> {
  var _isTitleEmpty = false;
  var _isLoading = false;
  final _titleController = TextEditingController();
  File? _pickedImage;
  PlaceLocation? _placeLocation;

  void _selectTheFile(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _selectPlaceLocation(double latitude, double longitude) {
    _placeLocation = PlaceLocation(latitude: latitude, longitude: longitude);
  }

  void _submitTheData() async {
    if (_titleController.text.isEmpty) {
      setState(() {
        _isTitleEmpty = true;
      });
      return;
    }
    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please take a picture'),
        ),
      );
      return;
    }
    if (_placeLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select the place location'),
        ),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<PlacesProvider>(context, listen: false).addPlace(
          title: _titleController.text,
          image: _pickedImage!,
          location: _placeLocation!);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Something went wrong!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final _isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a New Place'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: _isLandscape
                          ? const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20)
                          : const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: deviceSize.height * 0.02,
                          ),
                          SizedBox(
                            width: _isLandscape
                                ? deviceSize.width * 0.5
                                : double.infinity,
                            child: TextField(
                              controller: _titleController,
                              decoration: InputDecoration(
                                labelText: 'Title',
                                errorText: _isTitleEmpty
                                    ? 'Please Enter a Title'
                                    : null,
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                    borderSide: BorderSide(width: 1)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: _isLandscape
                                ? deviceSize.height * 0.05
                                : deviceSize.height * 0.02,
                          ),
                          ImageInput(_selectTheFile),
                          SizedBox(
                            height: _isLandscape
                                ? deviceSize.height * 0.05
                                : deviceSize.height * 0.02,
                          ),
                          LocationInput(_selectPlaceLocation),
                        ],
                      ),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  label: const Text('Add Place'),
                  icon: const Icon(Icons.add),
                  onPressed: _submitTheData,
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.secondary),
                      foregroundColor: MaterialStateProperty.all(Colors.black)),
                ),
              ],
            ),
    );
  }
}
