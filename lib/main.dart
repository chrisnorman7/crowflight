import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';

import 'json/settings.dart';
import 'pages/home_page.dart';
import 'pages/loading_page.dart';
import 'pages/permission_denied.dart';
import 'pages/service_disabled.dart';

Future<void> main() async {
  const String appTitle = 'Crowflight';
  runApp(MaterialApp(
    title: appTitle,
    home: LoadingPage(appTitle),
  ));
  final Settings settings = await Settings.getInstance();
  final Location location = Location();
  final bool serviceEnabled = await location.serviceEnabled();
  if (serviceEnabled == false) {
    return runApp(MaterialApp(
      title: appTitle,
      home: ServiceDisabledPage(),
    ));
  }
  PermissionStatus permissionGranted = await location.hasPermission();
  if (permissionGranted != PermissionStatus.granted) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return runApp(MaterialApp(
        title: appTitle,
        home: LocationDeniedPage(),
      ));
    }
  }
  runApp(MaterialApp(
    title: appTitle,
    home: HomePage(location, settings),
  ));
  await settings.save();
}
