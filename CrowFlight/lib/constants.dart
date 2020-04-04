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
const int arrivedVibrationDuration = 10;
const int movingVibrationDuration = 50;
const int distanceMultiplier = 100;
const int vibrateInterval = 50;

class Coordinates {
  double latitude;
  double longitude;
  double savedLatitude;
  double savedLongitude;
  double distance;
  double accuracy;
  double heading;
  String targetName;
}

final Coordinates coordinates = Coordinates();

const String savedPlacesListPreferenceName = 'savedPlaces';
List<SavedPlace> savedPlacesList = <SavedPlace>[];

final StreamController<List<SavedPlace>> savedPlacesStreamController = StreamController<List<SavedPlace>>.broadcast();
