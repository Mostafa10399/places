import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_complete_guide/helpers/location_helper.dart';

import '../models/place.dart';
import '../helpers/db_helpers.dart';

class GreatePlaces with ChangeNotifier {
  List<Place> _items = [];
  List<Place> get items {
    return [..._items];
  }

  Place findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> addPlace(
      String title, File pickedImage, PlaceLocation pickedLocation) async {
    final address = await LoactionHelpers.getPlaceAddress(
        pickedLocation.latitude, pickedLocation.longitude);
    print(address);
    final updatedLocation = PlaceLocation(
        latitude: pickedLocation.latitude,
        longitude: pickedLocation.longitude,
        address: address);

    final newPlace = Place(
        id: DateTime.now().toString(),
        image: pickedImage,
        location: updatedLocation,
        title: title);
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location.latitude,
      'loc_long': newPlace.location.longitude,
      'address': newPlace.location.address
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    print('x');
    _items = dataList
        .map((item) => Place(
            id: item['id'],
            image: File(item['image']),
            location: PlaceLocation(
                latitude: item['loc_lat'],
                longitude: item['loc_long'],
                address: item['address']),
            title: item['title']))
        .toList();
    notifyListeners();
  }
}
