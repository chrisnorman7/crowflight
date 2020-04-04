import 'dart:math';

import 'package:flutter/material.dart';

import 'constants.dart';

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

double bearing(double lat1, double lon1, double lat2, double lon2){
  final double y = sin(lon2 - lon1) * cos(lat2);
  final double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(lon2 - lon1);
  double brng = atan2(y, x);
  brng = radiansToDegrees(brng);
  return (brng + 360) % 360;
}

double distanceBetween(double lat1, double lon1, double lat2, double lon2) {
  const double R = 6371e3; // metres
  final double fi1 = degreesToRadians(lat1);
  final double fi2 = degreesToRadians(lat2);
  final double deltaLambda = degreesToRadians(lon2 - lon1);
  return acos(
    sin(fi1) * sin(fi2) + cos(fi1) * cos(fi2) *
    cos(deltaLambda)
  ) * R;
}

void pushRoute(BuildContext context, Widget route) {
  Navigator.push(
    context,
    MaterialPageRoute <void>(
      builder: (BuildContext context) => route
    )
  );
}

void updateSavedPlaces() {
  if (savedPlacesStreamController.hasListener == true) {
    savedPlacesStreamController.add(savedPlacesList);
  }
}
