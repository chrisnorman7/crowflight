/// Provides the [GpsPage] page.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../json/settings.dart';
import '../util.dart';

/// A piece of GPS information.
class GpsEntry {
  /// Create an entry.
  GpsEntry(this.title, this.value);

  /// The title of the entry.
  final String title;

  /// The value of the entry.
  final String value;
}

/// A page for showing GPS data.
class GpsPage extends StatefulWidget {
  /// Create a page.
  const GpsPage(this.settings);

  /// Application settings.
  final Settings settings;
  @override
  GpsPageState createState() => GpsPageState();
}

/// The state for [GpsPage].
class GpsPageState extends State<GpsPage> {
  StreamSubscription<Position>? _locationListener;
  Position? _location;

  @override
  Widget build(BuildContext context) {
    Widget child;
    final StreamSubscription<Position>? listener = _locationListener;
    final Position? position = _location;
    if (listener == null) {
      _locationListener = Geolocator.getPositionStream(
              desiredAccuracy: widget.settings.getAccuracy())
          .listen((Position event) {
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
      final int? floor = position.floor;
      final List<GpsEntry> entries = <GpsEntry>[
        GpsEntry('Heading', formatBearing(position.heading)),
        GpsEntry('Latitude', '${position.latitude} °'),
        GpsEntry('Longitude', '${position.longitude} °'),
        GpsEntry(
            'Altitude',
            (altitude == null)
                ? 'Unknown'
                : '${altitude.toStringAsFixed(2)} m'),
        GpsEntry('Speed',
            speed == null ? 'Unknown' : '${speed.toStringAsFixed(2)} m/s'),
        GpsEntry('Positional Accuracy',
            accuracy == null ? 'Unknown' : formatDistance(accuracy)),
        GpsEntry('Speed Accuracy',
            speedAccuracy == null ? 'Unknown' : formatDistance(speedAccuracy)),
        GpsEntry('Floor', floor == null ? 'Unknown' : 'Floor $floor}'),
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
