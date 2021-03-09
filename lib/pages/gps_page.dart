/// Provides the [GpsPage] page.
import 'dart:async';

import 'package:crowflight/util.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../json/settings.dart';

class GpsEntry {
  final String title;
  final String value;

  GpsEntry(this.title, this.value);
}

class GpsPage extends StatefulWidget {
  final Location location;
  final Settings settings;

  GpsPage(this.location, this.settings);
  @override
  GpsPageState createState() => GpsPageState();
}

class GpsPageState extends State<GpsPage> {
  StreamSubscription<LocationData>? _locationListener;
  LocationData? _location;

  @override
  Widget build(BuildContext context) {
    Widget child;
    final StreamSubscription<LocationData>? listener = _locationListener;
    final LocationData? position = _location;
    if (listener == null) {
      _locationListener =
          widget.location.onLocationChanged.listen((LocationData event) {
        setState(() {
          _location = event;
        });
      });
      child = Center(
        child: Text('Subscribing to location changes...'),
      );
    } else if (position == null) {
      child = Center(child: Text('Waiting for location updates...'));
    } else {
      final double? altitude = position.altitude;
      final double? speed = position.speed;
      final double? accuracy = position.accuracy;
      final double? speedAccuracy = position.speedAccuracy;
      final List<GpsEntry> entries = <GpsEntry>[
        GpsEntry('Heading', position.heading?.toStringAsFixed(2) ?? 'Unknown'),
        GpsEntry('Latitude', position.latitude.toString()),
        GpsEntry('Longitude', position.longitude.toString()),
        GpsEntry(
            'Altitude',
            (altitude == null)
                ? 'Unknown'
                : '${altitude.toStringAsFixed(2)} m'),
        GpsEntry('Speed',
            speed == null ? 'Unknown' : '${speed.toStringAsFixed(2)} m/s'),
        GpsEntry('Positional Accuracy',
            accuracy == null ? 'Unknown' : '${accuracy.toStringAsFixed(2)} m'),
        GpsEntry(
            'Speed Accuracy',
            speedAccuracy == null
                ? 'Unknown'
                : '${speedAccuracy.toStringAsFixed(2)} m'),
        GpsEntry('Requested Accuracy', enumName(widget.settings.accuracy))
      ];
      child = ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          final GpsEntry e = entries[index];
          return ListTile(title: Text(e.title), subtitle: Text(e.value));
        },
        itemCount: entries.length,
      );
    }
    return Scaffold(appBar: AppBar(title: Text('GPS Data')), body: child);
  }

  @override
  void dispose() {
    super.dispose();
    _locationListener?.cancel();
  }
}
