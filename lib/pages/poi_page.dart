/// Provides the [PoiPage] page.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:share/share.dart';

import '../json/settings.dart';
import '../util.dart';
import 'save_position.dart';

enum PoiMenuItems { rename, delete }

class PoiPage extends StatefulWidget {
  final Settings settings;
  final PointOfInterest poi;

  PoiPage(this.settings, this.poi);

  @override
  PoiPageState createState() => PoiPageState();
}

class PoiPageState extends State<PoiPage> {
  StreamSubscription<Position>? _locationListener;
  Position? _position;

  @override
  Widget build(BuildContext context) {
    Widget child;
    final Position? position = _position;
    double accuracy = widget.poi.accuracy;
    if (position != null) {
      accuracy += position.accuracy;
    }
    if (_locationListener == null || position == null) {
      child = Center(
        child: Text('Getting current location...'),
      );
      if (_locationListener == null) {
        _locationListener = Geolocator.getPositionStream(
                desiredAccuracy: widget.settings.getAccuracy())
            .listen((position) {
          setState(() {
            final Position? oldPosition = _position;
            if (oldPosition == null ||
                Geolocator.distanceBetween(
                        oldPosition.latitude,
                        oldPosition.longitude,
                        position.latitude,
                        position.longitude) <=
                    position.accuracy) {
              _position = position;
            }
          });
        });
      }
    } else {
      final PointOfInterest location = PointOfInterest(
          name: 'Current Location',
          latitude: position.latitude,
          longitude: position.longitude,
          accuracy: position.accuracy);
      child = ListView(children: [
        ListTile(
          title: Text('Directions'),
          subtitle: Semantics(
            liveRegion: true,
            child: Text(location.distanceBetween(widget.poi) <= accuracy
                ? 'Here'
                : location.directionsBetween(widget.poi)),
          ),
        ),
        ListTile(
          title: Text('Heading'),
          subtitle: Text(formatBearing(position.heading)),
        ),
        ListTile(
          title: Text('Latitude'),
          subtitle: Text(location.latitude.toString()),
        ),
        ListTile(
          title: Text('Longitude'),
          subtitle: Text(location.longitude.toString()),
        ),
        ListTile(
          title: Text('Speed'),
          subtitle: Text('${formatDistance(position.speed)}/s'),
        ),
        ListTile(
          title: Text('GPS Accuracy'),
          subtitle: Text(formatDistance(location.accuracy)),
        ),
        ListTile(
          title: Text('Altitude'),
          subtitle:
              Text('${formatDistance(position.altitude)} above sea level'),
        ),
        ListTile(
          title: Text('Apparent Storey'),
          subtitle: Text(
              position.floor == null ? 'Unknown' : 'Level ${position.floor}'),
        ),
        ListTile(
          title: Text('POI Accuracy'),
          subtitle: Text(formatDistance(widget.poi.accuracy)),
        ),
      ]);
    }
    return Scaffold(
      appBar: AppBar(title: Text(widget.poi.name), actions: [
        IconButton(
            tooltip: 'Share',
            icon: Icon(Icons.share),
            onPressed: () => Share.share(
                "I've saved the coordinates for ${widget.poi.name}.\n\nLatitude: ${widget.poi.latitude} °\nLongitude: ${widget.poi.longitude} °\n\nThese coordinates are accurate to within ${formatDistance(widget.poi.accuracy)}.",
                subject: 'Point of Interest')),
        widget.settings.pointsOfInterest.contains(widget.poi)
            ? PopupMenuButton<PoiMenuItems>(
                tooltip: 'Edit POI',
                icon: Icon(Icons.edit),
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    child: Text('Rename'),
                    value: PoiMenuItems.rename,
                  ),
                  PopupMenuItem(
                    child: Text('Delete'),
                    value: PoiMenuItems.delete,
                  )
                ],
                onSelected: (PoiMenuItems value) {
                  switch (value) {
                    case PoiMenuItems.rename:
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  SavePositionPage(
                                    widget.settings,
                                    (PointOfInterest poi) => setState(() {}),
                                    false,
                                    poi: widget.poi,
                                  )));
                      break;
                    case PoiMenuItems.delete:
                      if (widget.settings.pointsOfInterest
                          .contains(widget.poi)) {
                        setState(() {
                          widget.settings.pointsOfInterest.remove(widget.poi);
                          widget.settings.save();
                        });
                      }
                      break;
                  }
                },
              )
            : IconButton(
                icon: Icon(Icons.save),
                onPressed: () => setState(() {
                      widget.settings.pointsOfInterest.add(widget.poi);
                      widget.settings.save();
                    }))
      ]),
      body: child,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _locationListener?.cancel();
  }
}
