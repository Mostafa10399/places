import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../helpers/location_helper.dart';
import '../models/place.dart';
import '../screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  final Function handler;
  LocationInput(this.handler);
  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  var marker = HashSet<Marker>();

  // String _previewImageUrl;
  LocationData locData;
  PlaceLocation locPostion = PlaceLocation(latitude: null, longitude: null);
  Future<void> _getCurrentUserLocation() async {
    locData = await Location().getLocation();

    // final staticMapImageUrl = LoactionHelpers.generateLocationPreviewImage(
    //     latitude: locData.latitude, longitude: locData.longitude);
    setState(() {
      locPostion = PlaceLocation(
          latitude: locData.latitude, longitude: locData.longitude);
      // _previewImageUrl = staticMapImageUrl;
    });
    widget.handler(locData.latitude, locData.longitude);
  }

  Future<void> _pickLocation() async {
    locData = await Location().getLocation();

    final selectedLocation =
        await Navigator.of(context).push<LatLng>(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (ctx) {
              return MapScreen(
                locData: LatLng(locData.latitude, locData.longitude),
                isSelecting: true,
              );
            }));
    if (selectedLocation == null) {
      return;
    }
    setState(() {
      locPostion = PlaceLocation(
          latitude: selectedLocation.latitude,
          longitude: selectedLocation.longitude);
    });
    widget.handler(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            decoration:
                BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
            alignment: Alignment.center,
            height: 170,
            width: double.infinity,
            child: locData == null
                ? Text(
                    'No Location Choosen',
                    textAlign: TextAlign.center,
                  )
                : GoogleMap(
                    // scrollGesturesEnabled: false,
                    onCameraMove: (position) {},
                    markers: marker,
                    onMapCreated: (googleMapController) {
                      setState(() {
                        marker.add(
                          Marker(
                              markerId: MarkerId('1'),
                              position: LatLng(
                                  locPostion.latitude, locPostion.longitude)),
                        );
                      });
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(locPostion.latitude, locPostion.longitude),
                      zoom: 17.151926040649414,
                    ))
            // Image.network(
            //     _previewImageUrl,
            //     fit: BoxFit.cover,
            //     width: double.infinity,
            //   ),
            ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton.icon(
              onPressed: _getCurrentUserLocation,
              icon: Icon(Icons.location_on),
              label: Text('Current Location'),
              textColor: Theme.of(context).colorScheme.primary,
            ),
            FlatButton.icon(
              onPressed: _pickLocation,
              icon: Icon(Icons.map),
              label: Text('Select On Map'),
              textColor: Theme.of(context).colorScheme.primary,
            )
          ],
        )
      ],
    );
  }
}
