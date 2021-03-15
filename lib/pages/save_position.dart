/// Provides the [SavePositionPage] page.
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../cartesian_coordinates.dart';
import '../gps_coordinates.dart';
import '../json/settings.dart';
import '../util.dart';

class SavePositionPage extends StatefulWidget {
  final Settings settings;
  final void Function(PointOfInterest) onSave;
  final PointOfInterest? poi;
  final bool includeCoordinates;

  SavePositionPage(this.settings, this.onSave, this.includeCoordinates,
      {this.poi});

  SavePositionPageState createState() => SavePositionPageState();
}

class SavePositionPageState extends State<SavePositionPage> {
  List<GpsCoordinates> _coordinates = <GpsCoordinates>[];
  double? _latitude;
  double? _longitude;
  double? _accuracy;
  StreamSubscription<Position>? _locationListener;

  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (_locationListener == null && widget.includeCoordinates) {
      _locationListener = Geolocator.getPositionStream(
              desiredAccuracy: widget.settings.getAccuracy())
          .listen((event) {
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
          }
        });
      });
      child = Center(
        child: Text('Getting current position...'),
      );
    } else {
      if (_coordinates.isEmpty && widget.includeCoordinates) {
        child = Center(
          child: Text('Gathering coordinates...'),
        );
      } else {
        final double? accuracy = _accuracy;
        if (accuracy != null) {
          _coordinates.removeWhere((element) => element.accuracy > accuracy);
        }
        final double? lat, lon;
        if (_coordinates.isNotEmpty) {
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
          lon = atan2(y, x);
          final double hyp = sqrt(x * x + y * y);
          lat = atan2(z, hyp);
          _longitude = lon;
          _latitude = lat;
          _accuracy = [for (final c in _coordinates) c.accuracy]
                  .reduce((value, element) => value + element) /
              _coordinates.length;
        } else {
          lat = widget.poi?.latitude;
          lon = widget.poi?.longitude;
        }
        child = Form(
            key: _formState,
            child: ListView(
              children: [
                ListTile(
                  title: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (String? value) => value == null || value.isEmpty
                        ? 'You must supply a name'
                        : null,
                  ),
                ),
                ListTile(
                  title: Text('Latitude'),
                  subtitle:
                      Text(lat == null ? 'This is a bug' : lat.toString()),
                ),
                ListTile(
                    title: Text('Longitude'),
                    subtitle:
                        Text(lon == null ? 'This is a bug' : lon.toString())),
                Semantics(
                  child: ListTile(
                    title: Text('Accuracy'),
                    subtitle: Text(accuracy == null
                        ? 'Unknown'
                        : '${formatDistance(accuracy)} (${_coordinates.length} ${pluralise("point", _coordinates.length)}'),
                  ),
                  liveRegion: true,
                ),
              ],
            ));
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Save Current Position'),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              tooltip: 'Save',
              onPressed:
                  _latitude == null || _longitude == null || _accuracy == null
                      ? null
                      : () {
                          final double? lat = _latitude;
                          final double? lon = _longitude;
                          final double? accuracy = _accuracy;
                          if (lat != null &&
                              lon != null &&
                              accuracy != null &&
                              _formState.currentState?.validate() == true) {
                            final PointOfInterest poi = PointOfInterest(
                                name: _nameController.text,
                                latitude: lat,
                                longitude: lon,
                                accuracy: accuracy);
                            widget.onSave(poi);
                            Navigator.pop(context);
                          }
                        })
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
