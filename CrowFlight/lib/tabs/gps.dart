import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../constants.dart';
import '../utils.dart';
import 'base.dart';

class GpsTab extends StatefulWidget {
  @override
  GpsTabState createState() => GpsTabState();
}

class GpsTabState extends State<GpsTab> {
  double heading;
  double speed;
  double altitude;
  int lastUpdated;
  static String lastUpdatedString = 'Loading...';
  Timer timer;

  @override
  void initState() {
    super.initState();
    const Duration duration = Duration(seconds: lastUpdatedTimerInterval);
    timer = Timer.periodic(duration, (Timer t) {
      if (lastUpdated == null) {
        lastUpdatedString = 'Never';
      } else {
        final DateTime now = DateTime.now();
        final int nowSeconds = now.millisecondsSinceEpoch~/ 1000;
        if (lastUpdated > nowSeconds) {
          lastUpdatedString = 'Somehow in the future...';
        } else {
          final int seconds = nowSeconds - lastUpdated;
          final String plural = seconds == 1 ? 'second' : 'seconds';
          lastUpdatedString = '$seconds $plural ago';
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String speedString;
    if (speed == null) {
      speedString = loadingString;
    } else {
      final double metresPerHour = speed * 3600;
      final double kilometresPerHour = metresPerHour / 1000;
      speedString = '${kilometresPerHour.toStringAsFixed(2)} km/h';
    }
    String accuracyString;
    if (coordinates.accuracy == null) {
      accuracyString = 'Unknown';
    } else {
      accuracyString = distanceToString(coordinates.accuracy);
    }
    final List<Widget> rows = <Widget>[
      const Text('GPS Information'),
      Text('Latitude: ${coordinates.latitude == null ? loadingString : coordinates.latitude.toStringAsFixed(2)}'),
      Text('Longitude: ${coordinates.longitude == null ? loadingString : coordinates.longitude.toStringAsFixed(2)}'),
      Semantics(
        child: Text('Heading: ${heading == null ? "Unknown" : headingToString(heading)}'),
        liveRegion: true
      ),
      Text('Speed: $speedString'),
      Text('Altitude: ${altitude == null ? "Unknown" : distanceToString(altitude)}'),
      Text('Accuracy: $accuracyString'),
      Text('Last updated: $lastUpdatedString')
    ];
    location.onLocationChanged.listen((LocationData currentLocation) {
      if (mounted == true) {
        setState(() => updatePosition(currentLocation));
      } else {
        updatePosition(currentLocation);
      }
    });
    return ListView.builder(
      itemCount: rows.length * 2,
      itemBuilder: (BuildContext context, int index) {
        if (index.isOdd) {
          return const Divider(height: 50);
        } else {
          return rows[index ~/ 2];
        }
      }
    );
  }
  void updatePosition(LocationData currentPosition) {
    coordinates.latitude = currentPosition.latitude;
    coordinates.longitude = currentPosition.longitude;
    heading = currentPosition.heading;
    altitude = currentPosition.altitude;
    speed = currentPosition.speed;
    coordinates.accuracy = currentPosition.accuracy;
    lastUpdated = currentPosition.time ~/ 1000;
    if (coordinates.savedLatitude != null && coordinates.savedLongitude != null) {
      coordinates.distance = distanceBetween(coordinates.latitude, coordinates.longitude, coordinates.savedLatitude, coordinates.savedLongitude);
      coordinates.heading= bearing(coordinates.latitude, coordinates.longitude, coordinates.savedLatitude, coordinates.savedLongitude);
    }
  }
}

final CrowFlightTab gps = CrowFlightTab('GPS Information', Icons.gps_fixed, GpsTab());
