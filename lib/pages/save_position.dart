/// Provides the [SavePositionPage] page.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../json/settings.dart';
import '../util.dart';

/// A page for saving the current position.
class SavePositionPage extends StatefulWidget {
  /// Create the page.
  const SavePositionPage(this.settings, this.onSave, this.includeCoordinates,
      {this.poi});

  /// Application settings.
  final Settings settings;

  /// A function to be called when the POI is saved.
  final void Function(PointOfInterest) onSave;

  /// An optional POI to edit.
  final PointOfInterest? poi;

  /// If `true`, it will be possible to edit the coordinates for the POI.
  final bool includeCoordinates;

  @override
  SavePositionPageState createState() => SavePositionPageState();
}

/// State for [SavePositionPage].
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
  Position? _position;

  @override
  Widget build(BuildContext context) {
    Position? coords = _position;
    final PointOfInterest? poi = widget.poi;
    Widget child;
    if (_locationListener == null && widget.includeCoordinates) {
      _locationListener = Geolocator.getPositionStream(
              desiredAccuracy: widget.settings.getAccuracy())
          .listen((position) {
        setState(() {
          final Position? oldPosition = _position;
          if (oldPosition == null ||
              position.accuracy <= oldPosition.accuracy) {
            _position = position;
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
          coords = Position(
              longitude: poi.longitude,
              latitude: poi.latitude,
              timestamp: DateTime.now().toUtc(),
              accuracy: poi.accuracy,
              altitude: 0.0,
              heading: 0.0,
              speed: 0.0,
              speedAccuracy: 0.0);
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
              tooltip: 'Save',
              icon: Icon(Icons.save),
              onPressed: coords == null && poi == null
                  ? null
                  : () {
                      Position? coords = _position;
                      PointOfInterest? poi = widget.poi;
                      final PointOfInterest? oldPoi = poi;
                      if (coords == null) {
                        if (poi != null) {
                          coords = Position(
                              longitude: poi.longitude,
                              latitude: poi.latitude,
                              timestamp: DateTime.now().toUtc(),
                              accuracy: poi.accuracy,
                              altitude: 0.0,
                              heading: 0.0,
                              speed: 0.0,
                              speedAccuracy: 0.0);
                        } else {
                          throw Exception(
                              'Cannot create poi, when [widget.poi] is null ' +
                                  'and [widget.includeCoordinates] is false.');
                        }
                      }
                      if (_formState.currentState?.validate() == true) {
                        if (poi == null) {
                          poi = PointOfInterest.fromPosition(coords,
                              name: _nameController.text);
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
