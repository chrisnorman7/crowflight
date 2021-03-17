/// Provides the [SavePositionPage] page.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final PointOfInterest? poi = widget.poi;
    if (poi != null) {
      _nameController.text = poi.name;
    }
  }

  StreamSubscription<Position>? _locationListener;
  GpsCoordinates? _position;

  @override
  Widget build(BuildContext context) {
    GpsCoordinates? coords = _position;
    final PointOfInterest? poi = widget.poi;
    Widget child;
    if (_locationListener == null && widget.includeCoordinates) {
      _locationListener = Geolocator.getPositionStream(
              desiredAccuracy: widget.settings.getAccuracy())
          .listen((event) {
        setState(() {
          final GpsCoordinates? coords = _position;
          if (coords == null || event.accuracy <= coords.accuracy) {
            _position = GpsCoordinates.create(
                event.latitude, event.longitude, event.accuracy);
          }
        });
      });
      child = Center(
        child: Text('Getting current position...'),
      );
    } else {
      if (coords == null) {
        if (widget.includeCoordinates) {
          child = Center(
            child: Text('Gathering coordinates...'),
          );
        } else if (poi != null) {
          coords =
              GpsCoordinates.create(poi.latitude, poi.longitude, poi.accuracy);
        }
      }
      child = Form(
          key: _formState,
          child: ListView(
            children: [
              ListTile(
                title: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: nameValidator,
                ),
              ),
              ListTile(
                title: Text('Latitude'),
                subtitle: Text(coords == null
                    ? 'This is a bug!'
                    : coords.latitude.toString()),
              ),
              ListTile(
                  title: Text('Longitude'),
                  subtitle: Text(coords == null
                      ? 'This is a bug!'
                      : coords.longitude.toString())),
              Semantics(
                child: ListTile(
                  title: Text('Accuracy'),
                  subtitle: Text(coords == null
                      ? 'This is a bug!'
                      : formatDistance(coords.accuracy)),
                ),
                liveRegion: true,
              ),
            ],
          ));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Save POI'),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              tooltip: 'Save',
              onPressed: coords == null && poi == null
                  ? null
                  : () {
                      GpsCoordinates? coords = _position;
                      PointOfInterest? poi = widget.poi;
                      final PointOfInterest? oldPoi = poi;
                      if (coords == null) {
                        if (poi != null) {
                          coords = GpsCoordinates.create(
                              poi.latitude, poi.longitude, poi.accuracy);
                        } else {
                          throw ('Cannot create poi, when [widget.poi] is null and [widget.includeCoordinates] is false.');
                        }
                      }
                      if (_formState.currentState?.validate() == true) {
                        if (poi == null) {
                          poi = PointOfInterest(
                              name: _nameController.text,
                              latitude: coords.latitude,
                              longitude: coords.longitude,
                              accuracy: coords.accuracy);
                        } else {
                          poi.name = _nameController.text;
                        }
                        if (widget.settings.pointsOfInterest.contains(oldPoi)) {
                          widget.settings.pointsOfInterest.remove(oldPoi);
                          widget.settings.pointsOfInterest.add(poi);
                        }
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
