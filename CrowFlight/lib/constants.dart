import 'dart:async';
import 'package:location/location.dart';

import 'saved_place.dart';

const String loadingString = 'Loading...';
const String appName = 'CrowFlight';
final Location location = Location();
const int lastUpdatedTimerInterval = 1; // Given in seconds.
const int directionsTimerInterval = 200; // In milliseconds.

// All vibration durations given in milliseconds.
const String vibrationEnabledPreferenceName = 'vibrationEnabled';
bool vibrationEnabled = true;
const String arrivedVibrationDurationPreferenceName = 'arrivedVibrationDuration';
int arrivedVibrationDuration = 10;

const String movingVibrationDurationPreferenceName = 'movingVibrationDuration';
int movingVibrationDuration = 10;

const String distanceMultiplierPreferenceName = 'distanceMultiplier';
int distanceMultiplier = 100;

const String vibrateIntervalPreferenceName = 'vibrateInterval';
int vibrateInterval = 50;


const String gpsAccuracyPreferenceName = 'gpsAccuracy';
LocationAccuracy gpsAccuracy = LocationAccuracy.high;

class Coordinates {
  double latitude;
  double longitude;
  double savedLatitude;
  double savedLongitude;
  double distance;
  double accuracy;
  double heading;
  double headingToTarget;
  String targetName;
}

final Coordinates coordinates = Coordinates();

const String savedPlacesListPreferenceName = 'savedPlaces';
List<SavedPlace> savedPlacesList = <SavedPlace>[];

final StreamController<List<SavedPlace>> savedPlacesStreamController = StreamController<List<SavedPlace>>.broadcast();

enum CompassStyle {
  absolute,
  relative
}

const Map<CompassStyle,String> compassStyles = <CompassStyle, String>{
  CompassStyle.absolute: 'Absolute',
  CompassStyle.relative: 'Relative'
};

const String compassStylePreferenceName = 'compassStyle';
CompassStyle compassStyle = CompassStyle.absolute;

final Map<LocationAccuracy,String> gpsAccuracies = <LocationAccuracy,String>{
  LocationAccuracy.powerSave: 'Power saving',
  LocationAccuracy.low: 'Low',
  LocationAccuracy.balanced: 'Medium',
  LocationAccuracy.high: 'High'
};
