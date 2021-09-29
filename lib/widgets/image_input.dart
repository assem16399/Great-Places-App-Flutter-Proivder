import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as system_paths;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;
  ImageInput(this.onSelectImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;
  Future<void> _takePicture() async {
    final imagePicker = ImagePicker();
    final imageFile =
        await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);
    if (imageFile == null) return;

    var image = File(imageFile.path);
    setState(() {
      _storedImage = image;
    });
    // to get the paths that operating system gives us to store data
    final appDir = await system_paths.getApplicationDocumentsDirectory();
    // to get the name of the taken image by the camera
    final fileName = path.basename(image.path);
    // copy or store the image in the path we created
    final savedImage = await image.copy('${appDir.path}/$fileName');

    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final _isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Row(
      children: [
        Container(
          width:
              _isLandscape ? deviceSize.width * 0.45 : deviceSize.width * 0.5,
          height:
              _isLandscape ? deviceSize.height * 0.4 : deviceSize.height * 0.15,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: (_storedImage != null)
              ? Image.file(
                  _storedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : const Text(
                  'No Image Selected!',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(
          width:
              _isLandscape ? deviceSize.width * 0.15 : deviceSize.width * 0.05,
        ),
        Expanded(
          child: ElevatedButton.icon(
            label: const Text('Take a Picture'),
            icon: const Icon(Icons.camera),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.secondary),
            ),
            onPressed: _takePicture,
          ),
        )
      ],
    );
  }
}
