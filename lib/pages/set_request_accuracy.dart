/// Provides the [SetRequestAccuracyPage] page.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../json/settings.dart';
import '../util.dart';

/// A page for setting the requested GPS accuracy.
class SetRequestAccuracyPage extends StatefulWidget {
  /// Create the page.
  const SetRequestAccuracyPage(this.settings, this.onChange);

  /// Application settings.
  final Settings settings;

  /// A function to be called when the requested accuracy changes.
  final Function(LocationAccuracy?) onChange;

  @override
  SetRequestAccuracyPageState createState() => SetRequestAccuracyPageState();
}

/// A page for setting the requested GPS accuracy.
class SetRequestAccuracyPageState extends State<SetRequestAccuracyPage> {
  StreamSubscription<Position>? _locationListener;
  double? _accuracy;

  /// Change the requested accuracy.
  Future<void> changeAccuracy(LocationAccuracy? value) async {
    widget.settings.accuracy = value?.toString();
    await _locationListener?.cancel();
    trackLocation();
    await widget.settings.save();
    widget.onChange(value);
    setState(() {});
  }

  /// Start listening for location changes.
  void trackLocation() {
    _locationListener = Geolocator.getPositionStream(
            desiredAccuracy: widget.settings.getAccuracy())
        .listen((event) {
      setState(() {
        _accuracy = event.accuracy;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_locationListener == null) {
      trackLocation();
    }
    final LocationAccuracy? currentAccuracy = widget.settings.accuracy == null
        ? null
        : LocationAccuracy.values.firstWhere(
            (element) => element.toString() == widget.settings.accuracy);
    final List<LocationAccuracy?> menuItems = [null]
      ..addAll(LocationAccuracy.values);
    return Scaffold(
        appBar: AppBar(
          title: Text('Set Requested GPS Accuracy'),
        ),
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              final double? a = _accuracy;
              return Semantics(
                child: ListTile(
                  title: Text('Accuracy'),
                  subtitle: Text(a == null ? 'Loading...' : formatDistance(a)),
                ),
                liveRegion: true,
              );
            }
            index -= 1;
            final LocationAccuracy? accuracy = menuItems[index];
            return RadioListTile<LocationAccuracy?>(
              title: Text(enumName(accuracy?.toString())),
              groupValue: currentAccuracy,
              value: accuracy,
              onChanged: changeAccuracy,
            );
          },
          itemCount: menuItems.length + 1,
        ));
  }

  @override
  void dispose() {
    super.dispose();
    _locationListener?.cancel();
  }
}
