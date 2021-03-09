/// Provides the [HomePage] widget.
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../json/settings.dart';
import '../util.dart';
import 'gps_page.dart';
import 'save_position.dart';
import 'set_request_accuracy.dart';

enum MenuItems { gps, savePosition, setRequestedAccuracy }

class HomePage extends StatefulWidget {
  final Location location;
  final Settings settings;

  HomePage(this.location, this.settings);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final Widget child = ListView.builder(
        itemCount: widget.settings.pointsOfInterest.length,
        itemBuilder: (BuildContext context, int index) {
          final PointOfInterest poi = widget.settings.pointsOfInterest[index];
          return ListTile(
            title: Text(poi.name),
            subtitle: Text('${poi.latitude}, ${poi.longitude}'),
          );
        });
    return Scaffold(
      appBar: AppBar(
        leading: PopupMenuButton<MenuItems>(
          icon: Icon(Icons.menu),
          itemBuilder: (BuildContext context) => <PopupMenuItem<MenuItems>>[
            PopupMenuItem(
              child: Text('Save Current Position'),
              value: MenuItems.savePosition,
            ),
            PopupMenuItem(
              child: Text('GPS'),
              value: MenuItems.gps,
            ),
            PopupMenuItem(
              child: Text(
                  'Set requested accuracy (${enumName(widget.settings.accuracy)})'),
              value: MenuItems.setRequestedAccuracy,
            )
          ],
          onSelected: (MenuItems item) {
            switch (item) {
              case MenuItems.gps:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            GpsPage(widget.location, widget.settings)));
                break;
              case MenuItems.savePosition:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => SavePositionPage(
                            widget.location, widget.settings)));
                break;
              case MenuItems.setRequestedAccuracy:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            SetRequestAccuracyPage(
                                widget.location, widget.settings)));
                break;
            }
          },
        ),
        title: Text('Points of Interest'),
      ),
      body: child,
    );
  }
}
