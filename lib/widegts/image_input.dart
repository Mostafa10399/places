import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;
  ImageInput(this.onSelectImage);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  // Variables
  File _storedImage;

  //Methods

  Future<void> _takePictuer() async {
    final picker = ImagePicker();
    final imageFile =
        await picker.pickImage(source: ImageSource.camera, maxWidth: 600);

    setState(() {
      _storedImage = File(imageFile.path);
    });
    if (imageFile == null) {
      return;
    }

    final appDir = await syspath.getApplicationDocumentsDirectory();
    final fileName = path.basename(File(imageFile.path).path);
    final savedImage =
        await File(imageFile.path).copy('${appDir.path}/${fileName}');
    print(savedImage);
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: _storedImage != null
              ? Image.file(
                  _storedImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'No Image Taken',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
            child: FlatButton.icon(
          onPressed: _takePictuer,
          icon: Icon(Icons.camera),
          label: Text('Take Picture'),
          textColor: Theme.of(context).colorScheme.primary,
        ))
      ],
    );
  }
}
