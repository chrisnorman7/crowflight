import 'package:location/location.dart';

const String loadingString = 'Loading...';
const int metresPerKilometre = 1000;
const int secondsPerHour = 3600;
const String appName = 'CrowFlight';
final Location location = Location();
const int timerInterval = 5;

class Coordinates {
  double latitude;
  double longitude;
  double savedLatitude;
  double savedLongitude;
}

final Coordinates coordinates = Coordinates();
