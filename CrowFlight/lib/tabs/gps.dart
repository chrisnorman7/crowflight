import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../constants.dart';
import 'base.dart';

class GpsTab extends StatefulWidget {
  @override
  GpsTabState createState() => GpsTabState();
}

class GpsTabState extends State<GpsTab> {
  static double latitude;
  static double longitude;
  static double lastUpdated;
  static double speed;
  static double accuracy;

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
    String accuracyString;
    if (accuracy == null) {
      accuracyString = 'Unknown';
    } else {
      accuracyString = 'To within ${accuracy.toStringAsFixed(2)} m';
    }
    final Text accuracyWidget = Text('Accuracy: $accuracyString');
    String lastUpdatedString;
    if (lastUpdated == null) {
      lastUpdatedString = 'Not loaded yet';
    } else {
      final DateTime lastUpdatedDateTime = DateTime.fromMillisecondsSinceEpoch(lastUpdated.toInt());
      lastUpdatedString = '${lastUpdatedDateTime.hour}:${lastUpdatedDateTime.minute}:${lastUpdatedDateTime.second} (${lastUpdatedDateTime.year}-${lastUpdatedDateTime.month}-${lastUpdatedDateTime.day})';
    }
    final Text lastUpdatedWidget = Text('Last updated: $lastUpdatedString');
    final List<Widget> rows = <Widget>[
      header,
      latitudeWidget,
      longitudeWidget,
      speedWidget,
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
    lastUpdated = currentPosition.time;
  }
}

final CrowFlightTab gps = CrowFlightTab('GPS Information', Icons.gps_fixed, GpsTab());
