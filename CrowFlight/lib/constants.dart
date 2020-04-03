import 'package:location/location.dart';

const String loadingString = 'Loading...';
const int metresPerKilometre = 1000;
const int secondsPerHour = 3600;
const String appName = 'CrowFlight';
final Location location = Location();
const int lastUpdatedTimerInterval = 1; // Given in seconds.
const int directionsTimerInterval = 200; // In milliseconds.

// All vibration durations given in milliseconds.
const int arrivedVibrationDuration = 10;

class Coordinates {
  double latitude;
  double longitude;
  double savedLatitude;
  double savedLongitude;
  double distance;
  double accuracy;
  double bearing;
}

final Coordinates coordinates = Coordinates();
