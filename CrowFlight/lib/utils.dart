import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';

import 'constants.dart';
import 'saved_place.dart';

String distanceToString(num metres) {
  if (metres > 1000) {
    return '${(metres / 1000).toStringAsFixed(2)} km';
  } else {
    return '${metres.toStringAsFixed(2)} m';
  }
}

double degreesToRadians(double degrees) {
  return degrees * (pi / 180);
}

double radiansToDegrees(double radians) {
  return radians * 180 / pi;
}

double bearing(double lat1, double lon1, double lat2, double lon2) {
  final double y = sin(lon2 - lon1) * cos(lat2);
  final double x =
      cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(lon2 - lon1);
  double brng = atan2(y, x);
  brng = radiansToDegrees(brng);
  return (brng + 360) % 360;
}

double relativeBearing(double facing, double needToFace) {
  return (needToFace - facing) % 360;
}

double distanceBetween(double lat1, double lon1, double lat2, double lon2) {
  const double R = 6371e3; // metres
  final double fi1 = degreesToRadians(lat1);
  final double fi2 = degreesToRadians(lat2);
  final double deltaLambda = degreesToRadians(lon2 - lon1);
  return acos(sin(fi1) * sin(fi2) + cos(fi1) * cos(fi2) * cos(deltaLambda)) * R;
}

void pushRoute(BuildContext context, Widget route) {
  Navigator.push(context,
      MaterialPageRoute<void>(builder: (BuildContext context) => route));
}

void updateSavedPlaces() {
  if (savedPlacesStreamController.hasListener) {
    savedPlacesStreamController.add(savedPlacesList);
  }
}

String headingToString(double angle) {
  const List<String> directions = <String>[
    'north',
    'north-east',
    'east',
    'south-east',
    'south',
    'south-west',
    'west',
    'north-west'
  ];
  final int index =
      (((angle %= 360) < 0 ? angle + 360 : angle) ~/ 45 % 8).round();
  return '${angle.toStringAsFixed(0)} degrees ${directions[index]}';
}

Future<void> savePreferenceBool(String name, bool value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(name, value);
}

Future<void> savePreferenceString(String name, String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(name, value);
}

Future<void> savePreferenceInt(String name, int value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt(name, value);
}

Future<void> saveSavedPlaces() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<Map<String, dynamic>> json =
      savedPlacesList.map((SavedPlace place) {
    return place.toJson();
  }).toList();
  prefs.setString(savedPlacesListPreferenceName, jsonEncode(json));
}

Future<bool> changeGpsAccuracy(LocationAccuracy accuracy) {
  return location.changeSettings(
    accuracy: LocationAccuracy.high,
  );
}
