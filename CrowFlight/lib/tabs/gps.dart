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
  double accuracy;
  int lastUpdated;
  static String lastUpdatedString = 'Loading...';
  Timer timer;

  @override
  void initState() {
    super.initState();
    const Duration duration = Duration(seconds: timerInterval);
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
    const Text header = Text('GPS Information');
    final Text latitudeWidget = Text('Latitude: ${coordinates.latitude == null ? loadingString : coordinates.latitude.toStringAsFixed(2)}');
    final Text longitudeWidget = Text('Longitude: ${coordinates.longitude == null ? loadingString : coordinates.longitude.toStringAsFixed(2)}');
    String speedString;
    if (speed == null) {
      speedString = loadingString;
    } else {
      final double metresPerHour = speed * secondsPerHour;
      final double kilometresPerHour = metresPerHour / metresPerKilometre;
      speedString = '${kilometresPerHour.toStringAsFixed(2)} km/h';
    }
    final Text speedWidget = Text('Speed: $speedString');
    final Text altitudeWidget = Text('Altitude: ${altitude == null ? "Unknown" : distanceToString(altitude)}');
    String accuracyString;
    if (accuracy == null) {
      accuracyString = 'Unknown';
    } else {
      accuracyString = 'To within ${distanceToString(accuracy)}';
    }
    final Text accuracyWidget = Text('Accuracy: $accuracyString');
    final Text lastUpdatedWidget = Text('Last updated: $lastUpdatedString');
    final List<Widget> rows = <Widget>[
      header,
      latitudeWidget,
      longitudeWidget,
      speedWidget,
      altitudeWidget,
      accuracyWidget,
      lastUpdatedWidget
    ];
    location.onLocationChanged.listen((LocationData currentLocation) {
      if (mounted == true) {
        setState(() => updatePosition(currentLocation));
      } else {
        updatePosition(currentLocation);
      }
    });
    return ListView.builder(
      itemCount: rows.length,
      itemBuilder: (BuildContext context, int index) => rows[index]
    );
  }
  void updatePosition(LocationData currentPosition) {
    coordinates.latitude = currentPosition.latitude;
    coordinates.longitude = currentPosition.longitude;
    heading = currentPosition.heading;
    altitude = currentPosition.altitude;
    speed = currentPosition.speed;
    accuracy = currentPosition.accuracy;
    lastUpdated = currentPosition.time ~/ 1000;
  }
}

final CrowFlightTab gps = CrowFlightTab('GPS Information', Icons.gps_fixed, GpsTab());
