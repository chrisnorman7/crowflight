import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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
  final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (serviceEnabled == false) {
    return runApp(MaterialApp(
      title: appTitle,
      home: ServiceDisabledPage(),
    ));
  }
  LocationPermission permissionGranted = await Geolocator.checkPermission();
  if (permissionGranted == LocationPermission.denied ||
      permissionGranted == LocationPermission.deniedForever) {
    permissionGranted = await Geolocator.requestPermission();
    if (permissionGranted == LocationPermission.deniedForever) {
      return runApp(MaterialApp(
        title: appTitle,
        home: LocationDeniedPage(),
      ));
    }
  }
  runApp(MaterialApp(
    title: appTitle,
    home: HomePage(settings),
  ));
  await settings.save();
}
