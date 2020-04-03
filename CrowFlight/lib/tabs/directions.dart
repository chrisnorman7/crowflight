import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../constants.dart';
import '../utils.dart';

import 'base.dart';

class DirectionsTab extends StatefulWidget {
  @override
  DirectionsTabState createState() => DirectionsTabState();
}

class DirectionsTabState extends State<DirectionsTab> {

  @override
  Widget build(BuildContext context) {
    location.onLocationChanged.listen((LocationData currentLocation) {
      if (mounted == true) {
        setState(() => null);
      }
    });
    return ListView(
      children: <Widget>[
        Text((coordinates.savedLatitude == null || coordinates.savedLongitude == null) ? 'No coordinates have been saved.' : '${coordinates.savedLatitude.toStringAsFixed(2)},${coordinates.savedLongitude.toStringAsFixed(2)}'),
        Text((coordinates.savedLatitude == null || coordinates.savedLongitude == null) ? 'No directions needed.' : '${distanceToString(distanceBetween(coordinates.savedLatitude, coordinates.latitude, coordinates.savedLongitude, coordinates.longitude))} at ${bearing(coordinates.latitude, coordinates.savedLatitude, coordinates.longitude, coordinates.savedLongitude).toInt()} degrees.'),
        FloatingActionButton(
          onPressed: () {
            coordinates.savedLatitude = coordinates.latitude;
            coordinates.savedLongitude = coordinates.longitude;
          },
          tooltip: 'Save Current Coordinates',
          child: Icon(Icons.add),
        )
      ]
    );
  }
}

final CrowFlightTab directions = CrowFlightTab('Directions', Icons.directions_walk, DirectionsTab());
