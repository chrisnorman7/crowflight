import 'package:flutter/material.dart';

import '../constants.dart';
import '../utils.dart';

import 'base.dart';

class DirectionsTab extends StatefulWidget {
  @override
  DirectionsTabState createState() => DirectionsTabState();
}

class DirectionsTabState extends State<DirectionsTab> {
  static double savedLatitude;
  static double savedLongitude;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Text((savedLatitude == null || savedLongitude == null) ? 'No coordinates have been saved.' : '${savedLatitude.toStringAsFixed(2)},${savedLongitude.toStringAsFixed(2)}'),
        Text((savedLatitude == null || savedLongitude == null) ? 'No directions needed.' : '${distanceToString(distanceBetween(coordinates.latitude, savedLatitude, coordinates.longitude, savedLongitude))} at ${bearing(coordinates.latitude, savedLatitude, coordinates.longitude, savedLongitude)} degrees.')
      ]
    );
  }
}

final CrowFlightTab directions = CrowFlightTab('Directions', Icons.directions_walk, DirectionsTab());
