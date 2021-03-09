// / Provides the [Settings] class.

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../gps_coordinates.dart';

part 'settings.g.dart';

@JsonSerializable()
class PointOfInterest extends GpsCoordinates {
  final String name;

  PointOfInterest(
      {required this.name,
      required double latitude,
      required double longitude,
      required double accuracy})
      : super.create(latitude, longitude, accuracy);

  factory PointOfInterest.fromJson(Map<String, dynamic> json) =>
      _$PointOfInterestFromJson(json);
  Map<String, dynamic> toJson() => _$PointOfInterestToJson(this);
}

@JsonSerializable()
class Settings {
  final List<PointOfInterest> pointsOfInterest;
  String? accuracy;

  static Settings? _instance;
  static String _settingsKeyName = 'settings';

  Settings(
      {required List<PointOfInterest>? pointsOfInterest,
      required this.accuracy})
      : this.pointsOfInterest = pointsOfInterest ?? <PointOfInterest>[];

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);
  Map<String, dynamic> toJson() => _$SettingsToJson(this);

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
    return Settings.fromJson(jsonDecode(data));
  }

  Future<void> save() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String data = jsonEncode(this.toJson());
    await prefs.setString(_settingsKeyName, data);
  }
}
