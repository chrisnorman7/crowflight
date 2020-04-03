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
  static double latitude;
  static double longitude;
  static double speed;
  static double altitude;
  static double accuracy;
  static int lastUpdated;
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
          final String plural = nowSeconds == 1 ? 'second' : 'seconds';
          lastUpdatedString = '${nowSeconds - lastUpdated} $plural ago';
        }
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    const Text header = Text('GPS Information');
    final Text latitudeWidget = Text('Latitude: ${latitude == null ? loadingString : latitude.toStringAsFixed(2)}');
    final Text longitudeWidget = Text('Longitude: ${longitude == null ? loadingString : longitude.toStringAsFixed(2)}');
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
      accuracyString = 'To within ${accuracy.toStringAsFixed(2)} m';
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
      setState(() => updatePosition(currentLocation));
    });
    return ListView.builder(
      itemCount: rows.length,
      itemBuilder: (BuildContext context, int index) => rows[index]
    );
  }
  void updatePosition(LocationData currentPosition) {
    latitude = currentPosition.latitude;
    longitude = currentPosition.longitude;
    speed = currentPosition.speed;
    lastUpdated = currentPosition.time ~/ 1000;
  }
}

final CrowFlightTab gps = CrowFlightTab('GPS Information', Icons.gps_fixed, GpsTab());
