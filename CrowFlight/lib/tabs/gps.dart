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

  @override
  Widget build(BuildContext context) {
    const Text header = Text('GPS Information');
    final Text latitudeWidget = Text('Latitude: ${latitude == null ? "Loading..." : latitude.toStringAsFixed(2)}');
    final Text longitudeWidget = Text('Longitude: ${longitude == null ? "Loading..." : longitude.toStringAsFixed(2)}');
    String lastUpdatedString;
    if (lastUpdated == null) {
      lastUpdatedString = 'Not loaded yet';
    } else {
      final DateTime lastUpdatedDateTime = DateTime.fromMillisecondsSinceEpoch(lastUpdated.toInt());
      lastUpdatedString = '${lastUpdatedDateTime.hour}:${lastUpdatedDateTime.minute}:${lastUpdatedDateTime.second} (${lastUpdatedDateTime.year}-${lastUpdatedDateTime.month}-${lastUpdatedDateTime.day})';
    }
    final Text lastUpdatedWidget = Text('Last updated: $lastUpdatedString');
    final List<Widget> columns = <Widget>[header, latitudeWidget, longitudeWidget, lastUpdatedWidget];
    location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() => updatePosition(currentLocation));
    });
    return Column(
      children: columns
    );
  }
  
  void updatePosition(LocationData currentPosition) {
    latitude = currentPosition.latitude;
    longitude = currentPosition.longitude;
    lastUpdated = currentPosition.time;
  }
}

final CrowFlightTab gps = CrowFlightTab('GPS Information', Icons.gps_fixed, GpsTab());
