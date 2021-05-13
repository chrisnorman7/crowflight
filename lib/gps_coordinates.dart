/// Provides the [GpsCoordinates] class.

class GpsCoordinates {
  /// Create some coordinates.
  GpsCoordinates.create(this.latitude, this.longitude, this.accuracy);

  /// Latitude coordinate.
  final double latitude;

  /// Longitude coordinate.
  final double longitude;

  /// The accuracy of these coordinates.
  final double accuracy;
}
