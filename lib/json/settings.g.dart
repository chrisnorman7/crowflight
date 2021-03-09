// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PointOfInterest _$PointOfInterestFromJson(Map<String, dynamic> json) {
  return PointOfInterest(
    name: json['name'] as String,
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
    accuracy: (json['accuracy'] as num).toDouble(),
  );
}

Map<String, dynamic> _$PointOfInterestToJson(PointOfInterest instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'accuracy': instance.accuracy,
      'name': instance.name,
    };

Settings _$SettingsFromJson(Map<String, dynamic> json) {
  return Settings(
    pointsOfInterest: (json['pointsOfInterest'] as List<dynamic>?)
        ?.map((e) => PointOfInterest.fromJson(e as Map<String, dynamic>))
        .toList(),
    accuracy: json['accuracy'] as String?,
  );
}

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'pointsOfInterest': instance.pointsOfInterest,
      'accuracy': instance.accuracy,
    };
