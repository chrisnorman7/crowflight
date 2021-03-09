/// Provides the [SavePositionPage] page.
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../cartesian_coordinates.dart';
import '../gps_coordinates.dart';
import '../util.dart';

enum SavePositionStrategy { manual, automatic }

class SavePositionPage extends StatefulWidget {
  final Location location;

  SavePositionPage(this.location);

  SavePositionPageState createState() => SavePositionPageState();
}

class SavePositionPageState extends State<SavePositionPage> {
  SavePositionStrategy _strategy = SavePositionStrategy.automatic;
  List<GpsCoordinates> _coordinates = <GpsCoordinates>[];
  double? _latitude;
  double? _longitude;
  double? _accuracy;
  StreamSubscription<LocationData>? _locationListener;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (_locationListener == null) {
      _locationListener = widget.location.onLocationChanged.listen((event) {
        setState(() {
          final double? latitude = event.latitude;
          final double? longitude = event.longitude;
          final double? accuracy = event.accuracy;
          final double? averageAccuracy = _accuracy;
          if (latitude != null &&
              longitude != null &&
              accuracy != null &&
              (averageAccuracy == null || accuracy <= averageAccuracy)) {
            _coordinates
                .add(GpsCoordinates.create(latitude, longitude, accuracy));
          } else {
            print(accuracy);
          }
        });
      });
      child = Center(
        child: Text('Getting current position...'),
      );
    } else if (_strategy == SavePositionStrategy.automatic) {
      if (_coordinates.isEmpty) {
        child = Center(
          child: Text('Gathering coordinates...'),
        );
      } else {
        final double? accuracy = _accuracy;
        if (accuracy != null) {
          _coordinates.removeWhere((element) => element.accuracy > accuracy);
        }
        // Calculate the average of all the coordinates.
        double x = 0;
        double y = 0;
        double z = 0;
        final List<CartesianCoordinates> cartesianCoordinates =
            <CartesianCoordinates>[];
        for (final GpsCoordinates coordinates in _coordinates) {
          final cart = CartesianCoordinates(
              cos(coordinates.latitude) * cos(coordinates.longitude),
              cos(coordinates.latitude) * sin(coordinates.longitude),
              sin(coordinates.latitude));
          cartesianCoordinates.add(cart);
          x += cart.x;
          y += cart.y;
          z += cart.z;
        }
        x /= cartesianCoordinates.length;
        y /= cartesianCoordinates.length;
        z /= cartesianCoordinates.length;
        final double lon = atan2(y, x);
        final double hyp = sqrt(x * x + y * y);
        final double lat = atan2(z, hyp);
        _longitude = lon;
        _latitude = lat;
        _accuracy = [for (final c in _coordinates) c.accuracy]
                .reduce((value, element) => value + element) /
            _coordinates.length;
        child = ListView(
          children: [
            ListTile(
              title: Text('Latitude'),
              subtitle: Text(lat.toString()),
            ),
            ListTile(title: Text('Longitude'), subtitle: Text(lon.toString())),
            Semantics(
              child: ListTile(
                title: Text('Accuracy'),
                subtitle: Text(accuracy == null
                    ? 'Unknown'
                    : '${formatDistance(accuracy)} (${_coordinates.length} ${pluralise("point", _coordinates.length)}'),
              ),
              liveRegion: true,
            ),
            ListTile(
              title: Text('Save'),
              onTap: () => print('$_latitude, $_longitude'),
            )
          ],
        );
      }
    } else {
      child = Text('No form yet.');
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Save Current Position'),
        actions: [
          IconButton(
              tooltip: _strategy == SavePositionStrategy.automatic
                  ? 'Manual'
                  : 'Automatic',
              icon: Icon(_strategy == SavePositionStrategy.manual
                  ? Icons.computer
                  : Icons.person),
              onPressed: () => setState(() => _strategy =
                  (_strategy == SavePositionStrategy.automatic
                      ? SavePositionStrategy.manual
                      : SavePositionStrategy.automatic)))
        ],
      ),
      body: child,
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_locationListener != null) {
      _locationListener?.cancel();
    }
  }
}
