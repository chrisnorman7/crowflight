/// Provides the [PoiPage] page.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../json/settings.dart';
import '../util.dart';

class PoiPage extends StatefulWidget {
  final Settings settings;
  final PointOfInterest poi;

  PoiPage(this.settings, this.poi);

  @override
  PoiPageState createState() => PoiPageState();
}

class PoiPageState extends State<PoiPage> {
  StreamSubscription<Position>? _locationListener;
  PointOfInterest? _location;
  double? _heading;

  @override
  Widget build(BuildContext context) {
    Widget child;
    final PointOfInterest? location = _location;
    double accuracy = (location?.accuracy ?? 0.0) + widget.poi.accuracy;
    if (_locationListener == null || location == null) {
      child = Center(
        child: Text('Getting current location...'),
      );
      if (_locationListener == null) {
        _locationListener = Geolocator.getPositionStream(
                desiredAccuracy: widget.settings.getAccuracy())
            .listen((event) {
          setState(() {
            _heading = event.heading;
            final PointOfInterest poi = PointOfInterest(
                name: 'Current location',
                latitude: event.latitude,
                longitude: event.longitude,
                accuracy: event.accuracy);
            final PointOfInterest? location = _location;
            if (location == null || location.distanceBetween(poi) <= 2.0) {
              _location = poi;
            }
          });
        });
      }
    } else if (location.distanceBetween(widget.poi) <= accuracy) {
      child = Center(
        child: Semantics(
          liveRegion: true,
          child: Text('Within ${formatDistance(accuracy)}'),
        ),
      );
    } else {
      final double? heading = _heading;
      child = ListView(
        children: [
          ListTile(
            title: Text('Directions'),
            subtitle: Semantics(
              liveRegion: true,
              child: Text(location.directionsBetween(widget.poi)),
            ),
          ),
          ListTile(
            title: Text('Heading'),
            subtitle:
                Text(heading == null ? 'Unknown' : formatBearing(heading)),
          )
        ],
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.poi.name),
      ),
      body: child,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _locationListener?.cancel();
  }
}
