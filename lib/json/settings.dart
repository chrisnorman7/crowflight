// / Provides the [Settings] class.
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../gps_coordinates.dart';
import '../util.dart';

part 'settings.g.dart';

/// A point of interest.
///
/// This class is used to show the points on the main screen.
@JsonSerializable()
class PointOfInterest extends GpsCoordinates {
  /// Create a POI.
  PointOfInterest(
      {required this.name,
      required double latitude,
      required double longitude,
      required double accuracy})
      : super.create(latitude, longitude, accuracy);

  /// Create a POI from JSON.
  factory PointOfInterest.fromJson(Map<String, dynamic> json) =>
      _$PointOfInterestFromJson(json);

  /// Create a POI from a GPS position.
  factory PointOfInterest.fromPosition(Position position,
          {String name = 'Current location'}) =>
      PointOfInterest(
          name: name,
          latitude: position.latitude,
          longitude: position.longitude,
          accuracy: position.accuracy);

  /// The name of the POI.
  String name;

  /// Dump to JSON.
  Map<String, dynamic> toJson() => _$PointOfInterestToJson(this);

  /// Return the distance between two points.
  double? distanceBetween(PointOfInterest other) {
    final double distance = Geolocator.distanceBetween(
        latitude, longitude, other.latitude, other.longitude);
    if (distance > accuracy) {
      return distance - accuracy;
    }
  }

  /// Return the bearing between two points.
  double bearingBetween(PointOfInterest other, double initialHeading) {
    final double bearing = Geolocator.bearingBetween(
        latitude, longitude, other.latitude, other.longitude);
    return (bearing - initialHeading) % 360;
  }

  /// Return the directions between two points.
  String directionsBetween(PointOfInterest other, double initialHeading) {
    final double? distance = distanceBetween(other);
    if (distance == null) {
      return 'here';
    }
    return '${formatDistance(distance)} ' +
        formatBearing(bearingBetween(other, initialHeading));
  }

  /// Return geo coordinates.
  String coordinatesString() => '$latitude ° latitude, $longitude ° longitude';
}

/// App settings.
@JsonSerializable()
class Settings {
  /// Default constructor.
  Settings({required this.accuracy, List<PointOfInterest>? pointsOfInterest})
      : this.pointsOfInterest = pointsOfInterest ??
            <PointOfInterest>[
              PointOfInterest(
                  name: 'Statue of Liberty',
                  latitude: 40.689263,
                  longitude: -74.044505,
                  accuracy: 0.0)
            ];

  /// Create settings from JSON.
  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);

  /// All points of interest.
  final List<PointOfInterest> pointsOfInterest;

  /// The accuracy desired by the user.
  ///
  /// This is the name of a [LocationAccuracy] member.
  String? accuracy;

  static Settings? _instance;
  static String _settingsKeyName = 'settings';

  /// Dump to JSON.
  Map<String, dynamic> toJson() => _$SettingsToJson(this);

  /// Get an instance.
  ///
  /// This method may returned a cached instance.
  static Future<Settings> getInstance() async {
    final Settings? i = _instance;
    if (i != null) {
      return i;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? data = await prefs.getString(_settingsKeyName);
    if (data == null) {
      final Settings s =
          Settings(pointsOfInterest: <PointOfInterest>[], accuracy: null);
      await s.save();
      _instance = s;
      return s;
    }
    return Settings.fromJson(jsonDecode(data) as Map<String, dynamic>);
  }

  /// Clear saved settings.
  static Future<void> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// Save settings.
  Future<void> save() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String data = jsonEncode(this.toJson());
    await prefs.setString(_settingsKeyName, data);
  }

  /// Get location accuracy from [accuracy].
  LocationAccuracy getAccuracy() {
    final String? a = accuracy;
    if (a != null) {
      return LocationAccuracy.values
          .firstWhere((element) => element.toString().endsWith(a));
    }
    return LocationAccuracy.medium;
  }
}
