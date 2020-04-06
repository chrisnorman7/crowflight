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
  double speed;
  double altitude;
  double lastUpdated;
  String lastUpdatedString = 'Loading...';
  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: lastUpdatedTimerInterval), (Timer t) {
      if (mounted) {
        setState(() {
          if (lastUpdated == null) {
            lastUpdatedString = 'Never';
          } else {
            final DateTime now = DateTime.now();
            final int nowSeconds = now.millisecondsSinceEpoch;
            if (lastUpdated > nowSeconds) {
              lastUpdatedString = 'Now';
            } else {
              final double seconds = (nowSeconds - lastUpdated) / 1000;
              lastUpdatedString = '${seconds.toStringAsFixed(2)} seconds ago';
            }
          }
        });
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
      Text('Latitude: ${coordinates.latitude ?? loadingString}'),
      Text('Longitude: ${coordinates.longitude ?? loadingString}'),
      Semantics(
        child: Text('Heading: ${coordinates.heading == null ? "Unknown" : headingToString(coordinates.heading)}'),
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
    coordinates.heading = currentPosition.heading;
    altitude = currentPosition.altitude;
    speed = currentPosition.speed;
    coordinates.accuracy = currentPosition.accuracy;
    lastUpdated = currentPosition.time;
    if (coordinates.savedLatitude != null && coordinates.savedLongitude != null) {
      coordinates.distance = distanceBetween(coordinates.latitude, coordinates.longitude, coordinates.savedLatitude, coordinates.savedLongitude);
      coordinates.headingToTarget = bearing(coordinates.latitude, coordinates.longitude, coordinates.savedLatitude, coordinates.savedLongitude);
    }
  }
}

final CrowFlightTab gps = CrowFlightTab('GPS Information', Icons.gps_fixed, GpsTab());
