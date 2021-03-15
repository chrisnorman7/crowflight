/// Provides the [SetRequestAccuracyPage] page.
import 'dart:async';

import 'package:crowflight/util.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../json/settings.dart';

class SetRequestAccuracyPage extends StatefulWidget {
  final Settings settings;

  SetRequestAccuracyPage(this.settings);

  @override
  SetRequestAccuracyPageState createState() => SetRequestAccuracyPageState();
}

class SetRequestAccuracyPageState extends State<SetRequestAccuracyPage> {
  StreamSubscription<Position>? _locationListener;
  double? _accuracy;

  Future<void> changeAccuracy(LocationAccuracy? value) async {
    widget.settings.accuracy = value?.toString();
    await _locationListener?.cancel();
    startListening();
    await widget.settings.save();
    setState(() {});
  }

  void startListening() {
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
      startListening();
    }
    final LocationAccuracy? currentAccuracy = widget.settings.accuracy == null
        ? null
        : LocationAccuracy.values.firstWhere(
            (element) => element.toString() == widget.settings.accuracy);
    final List<LocationAccuracy?> menuItems = [null];
    menuItems.addAll(LocationAccuracy.values);
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
            return ListTile(
              title: Text(enumName(accuracy?.toString())),
              subtitle: Radio<LocationAccuracy?>(
                groupValue: currentAccuracy,
                value: accuracy,
                onChanged: changeAccuracy,
              ),
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
