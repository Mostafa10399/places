import 'dart:io';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../widegts/image_input.dart';
import '../providers/great_places.dart';
import '../widegts/location_input.dart';
import '../screens/map_screen.dart';
import '../models/place.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add_place';
  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
//Variables
  final _titleController = TextEditingController();
  File _pickedImage;
  PlaceLocation _pickedLocation;
//Methods
  void _selectImage(File pickedImage) {
    setState(() {
      _pickedImage = pickedImage;
      print(_pickedImage);
    });
  }

  void _selectPlace(double lat, double lon) {
    _pickedLocation = PlaceLocation(latitude: lat, longitude: lon);
  }

  void _savedPlace() {
    if (_titleController.text.isEmpty || _pickedImage == null||_pickedLocation == null) {
      return;
    }
    Provider.of<GreatePlaces>(context, listen: false)
        .addPlace(_titleController.text, _pickedImage,_pickedLocation);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add a New Place')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Title'),
                    controller: _titleController,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ImageInput(_selectImage),
                  SizedBox(
                    height: 10,
                  ),
                  LocationInput(_selectPlace)
                ],
              ),
            ),
          )),
          RaisedButton.icon(
            onPressed: _savedPlace,
            icon: Icon(Icons.add),
            label: Text('Add Place'),
            elevation: 0,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ],
      ),
    );
  }
}
