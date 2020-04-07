class SavedPlace {
  SavedPlace({this.latitude, this.longitude, this.title});

  double latitude, longitude;
  String title;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'latitude': latitude,
      'longitude': longitude
    };
  }
}
