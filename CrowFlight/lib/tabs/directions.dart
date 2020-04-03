import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

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
      if (mounted == true) {
        setState(() => null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String savedCoordinatesString;
    if (coordinates.savedLatitude == null || coordinates.savedLongitude == null) {
      savedCoordinatesString = 'No coordinates have been saved yet.';
    } else {
      savedCoordinatesString = '${coordinates.savedLatitude},${coordinates.savedLongitude}';
    }
    String directionsString;
    if (coordinates.savedLatitude == null || coordinates.savedLongitude == null) {
      directionsString = 'No directions needed.';
    } else if (coordinates.distance == null) {
      directionsString = 'Loading directions...';
    } else if (coordinates.distance <= coordinates.accuracy) {
      Vibration.vibrate(duration: arrivedVibrationDuration);
      directionsString = 'Within ${distanceToString(coordinates.accuracy)}.';
    } else {
      directionsString = '${distanceToString(coordinates.distance)} at ${coordinates.bearing.toInt()} degrees.';
    }
    final List<Widget> rows = <Widget>[
      FloatingActionButton(
        onPressed: () {
          coordinates.savedLatitude = coordinates.latitude;
          coordinates.savedLongitude = coordinates.longitude;
        },
        tooltip: 'Save Current Coordinates',
        child: Icon(Icons.add),
      ),
      Text(savedCoordinatesString),
      Text(directionsString),
      RaisedButton(
        child: const Text('Clear Saved Coordinates'),
        onPressed: () {
          coordinates.savedLatitude = null;
          coordinates.savedLongitude = null;
        }
      )
    ];
    return ListView.builder(
      itemCount: rows.length * 2,
      itemBuilder: (BuildContext context, int index) {
        if (index.isOdd) {
          return const Divider(height: 100);
        } else {
          return rows[index ~/ 2];
        }
      }
    );
  }
}

final CrowFlightTab directions = CrowFlightTab('Directions', Icons.directions_walk, DirectionsTab());
