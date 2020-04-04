import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';
import 'get_location.dart';
import 'saved_place.dart';

import 'tabs/base.dart';
import 'tabs/directions.dart';
import 'tabs/gps.dart';
import 'tabs/saved_places.dart';
import 'tabs/settings.dart';

Future<void> main() async {
  runApp(CheckLocationPermissionsWidget());
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  vibrationEnabled = prefs.getBool(vibrationEnabledPreferenceName) ?? vibrationEnabled;
  compassStyle = prefs.getInt(compassStylePreferenceName) ?? compassStyle;
  final String savedPlacesJson = prefs.getString(savedPlacesListPreferenceName);
  if (savedPlacesJson == null) {
    if (savedPlacesList.isEmpty == true) {
      <SavedPlace>[
        SavedPlace(
          latitude: -31.5077519,
          longitude: 115.598664,
          title: 'Entrance to Two Rocks dunes'
        ),
        SavedPlace(
          latitude: -31.5119972,
          longitude: 115.5970434,
          title: 'Exit from Two Rocks dunes'
        ),
        SavedPlace(
          latitude: 52.4472342,
          longitude: -1.4701047,
          title: 'Bench by the Wyken Slough'
        )
      ].forEach(savedPlacesList.add);
    }
  } else {
    final dynamic mapList = jsonDecode(savedPlacesJson);
    mapList.forEach((dynamic element) {
      savedPlacesList.add(
        SavedPlace(
          title: element['title'], // ignore: argument_type_not_assignable
          latitude: element['latitude'], // ignore: argument_type_not_assignable
          longitude: element['longitude'] // ignore: argument_type_not_assignable
        )
      );
    });
  }
  bool serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
  }
  PermissionStatus permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
  }
    if (serviceEnabled && permissionGranted == PermissionStatus.granted) {
    await location.changeSettings(accuracy: LocationAccuracy.high);
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