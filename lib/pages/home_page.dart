// / Provides the [HomePage] widget.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:share/share.dart';

import '../json/settings.dart';
import '../util.dart';
import 'gps_page.dart';
import 'navigate_page.dart';
import 'poi_page.dart';
import 'save_position.dart';
import 'set_request_accuracy.dart';

enum MainMenuItems { savePosition, navigate, gps, setRequestedAccuracy }

class HomePage extends StatefulWidget {
  final Settings settings;

  HomePage(this.settings);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  StreamSubscription<Position>? _locationListener;
  PointOfInterest? _location;
  double? _heading;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (widget.settings.pointsOfInterest.isEmpty) {
      child = Center(child: Text('No points of interest to show.'));
    } else if (_locationListener == null || _location == null) {
      if (_locationListener == null) {
        trackLocation();
      }
      child = Center(
        child: Text('Getting location...'),
      );
    } else {
      child = ListView.builder(
          itemCount: widget.settings.pointsOfInterest.length,
          itemBuilder: (BuildContext context, int index) {
            final PointOfInterest poi = widget.settings.pointsOfInterest[index];
            final PointOfInterest? location = _location;
            String directions = 'Loading directions';
            if (location != null) {
              if (location.distanceBetween(poi) == 0.0) {
                directions = 'Here';
              } else {
                directions =
                    location.directionsBetween(poi, initialHeading: _heading);
              }
            }
            directions = '$directions (${poi.coordinatesString()})';
            return ListTile(
              title: Text(poi.name),
              subtitle: Text(directions),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          PoiPage(widget.settings, poi))),
            );
          });
    }
    final PointOfInterest? location = _location;
    return Scaffold(
      appBar: AppBar(
        leading: PopupMenuButton<MainMenuItems>(
          icon: Icon(Icons.menu),
          itemBuilder: (BuildContext context) => <PopupMenuItem<MainMenuItems>>[
            PopupMenuItem(
              child: Text('Save Current Position'),
              value: MainMenuItems.savePosition,
            ),
            PopupMenuItem(
              child: Text('Navigate to Coordinates'),
              value: MainMenuItems.navigate,
            ),
            PopupMenuItem(
              child: Text('GPS Data'),
              value: MainMenuItems.gps,
            ),
            PopupMenuItem(
              child: Text(
                  'Change Requested Accuracy (${enumName(widget.settings.accuracy)})'),
              value: MainMenuItems.setRequestedAccuracy,
            )
          ],
          onSelected: (MainMenuItems item) {
            switch (item) {
              case MainMenuItems.gps:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            GpsPage(widget.settings)));
                break;
              case MainMenuItems.savePosition:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => SavePositionPage(
                            widget.settings,
                            (PointOfInterest poi) => setState(() {
                                  widget.settings.pointsOfInterest.add(poi);
                                  widget.settings.save();
                                }),
                            true)));
                break;
              case MainMenuItems.setRequestedAccuracy:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            SetRequestAccuracyPage(widget.settings,
                                (LocationAccuracy? accuracy) async {
                              await _locationListener?.cancel();
                              trackLocation();
                            })));
                break;
              case MainMenuItems.navigate:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            NavigatePage(widget.settings)));
                break;
            }
          },
        ),
        title: Text('Points of Interest'),
        actions: [
          IconButton(
              tooltip: 'Share',
              icon: Icon(Icons.share),
              onPressed: location == null
                  ? null
                  : () => Share.share(
                      'I am currently located within ${formatDistance(location.accuracy)} of ${location.latitude} ° latitude, ${location.longitude} ° longitude.'))
        ],
      ),
      body: child,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _locationListener?.cancel();
  }

  void trackLocation() {
    _locationListener = Geolocator.getPositionStream(
            desiredAccuracy: widget.settings.getAccuracy())
        .listen((Position location) => setState(() {
              _heading = location.heading;
              final double? lat = location.latitude;
              final double? lon = location.longitude;
              final double? accuracy = location.accuracy;
              if (lat != null && lon != null && accuracy != null) {
                _location = PointOfInterest(
                    name: 'Current location',
                    longitude: lon,
                    latitude: lat,
                    accuracy: accuracy);
              }
            }));
  }
}
