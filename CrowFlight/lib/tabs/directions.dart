import 'dart:async';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../utils.dart';

import 'base.dart';

class DirectionsTab extends StatefulWidget {
  @override
  DirectionsTabState createState() => DirectionsTabState();
}

class DirectionsTabState extends State<DirectionsTab> {
  Timer timer;

  @override
  void initState() {
    super.initState();
    const Duration duration = Duration(milliseconds: 250);
    timer = Timer.periodic(duration, (Timer t) {
      setState(() => null);
    });
  }

  @override
  Widget build(BuildContext context) {
    String directionsString;
    if (coordinates.savedLatitude == null || coordinates.savedLongitude == null) {
      directionsString = 'No directions needed.';
    } else if (coordinates.distance == null) {
      directionsString = 'Loading directions...';
    } else if (coordinates.distance <= coordinates.accuracy) {
      directionsString = 'Within ${distanceToString(coordinates.accuracy)}.';
    } else {
      directionsString = '${distanceToString(coordinates.distance)} at ${coordinates.bearing.toInt()} degrees.';
    }
    return ListView(
      children: <Widget>[
        Text((coordinates.savedLatitude == null || coordinates.savedLongitude == null) ? 'No coordinates have been saved.' : '${coordinates.savedLatitude.toStringAsFixed(2)},${coordinates.savedLongitude.toStringAsFixed(2)}'),
        Text(directionsString),
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
