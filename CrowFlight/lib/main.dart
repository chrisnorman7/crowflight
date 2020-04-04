import 'package:flutter/material.dart';
import 'package:location/location.dart';

import 'constants.dart';
import 'get_location.dart';

import 'tabs/base.dart';
import 'tabs/directions.dart';
import 'tabs/gps.dart';
import 'tabs/saved_places.dart';
import 'tabs/settings.dart';

Future<void> main() async {
  runApp(CheckLocationPermissionsWidget());
  bool serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
  }
  PermissionStatus permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
  }
    if (serviceEnabled && permissionGranted == PermissionStatus.granted) {
    runApp(MyApp());
  } else {
    runApp(NoLocationPermissionWidget());
  }
}

class MyApp extends StatelessWidget {
  final List<CrowFlightTab> tabs = <CrowFlightTab>[
    gps,
    directions,
    savedPlaces,
    settings,
  ];

  @override
  Widget build(BuildContext context) {
    final DefaultTabController tabController = DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: tabs.map(
              (CrowFlightTab tab) => Tab(
                text: tab.title,
                icon: Icon(tab.icon)
              )
            ).toList()
          ),
          title: const Text(appName),
        ),
        body: TabBarView(
          children: tabs.map(
            (CrowFlightTab tab) => tab.widget
          ).toList()
        )
      )
    );
    return MaterialApp(
      home: tabController
    );
  }
}