import 'dart:io';

import 'package:flutter/material.dart';
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
  final _titleController = TextEditingController();
  File? _pickedImage;
  void _selectTheFile(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _submitTheData() {
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
    Provider.of<PlacesProvider>(context, listen: false)
        .addPlace(title: _titleController.text, image: _pickedImage!);
    Navigator.of(context).pop();
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: _isLandscape
                    ? const EdgeInsets.symmetric(horizontal: 10, vertical: 20)
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
                          errorText:
                              _isTitleEmpty ? 'Please Enter a value' : null,
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
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
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
