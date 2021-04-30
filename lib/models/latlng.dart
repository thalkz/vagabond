// Point in the WGS84 projection
// https://epsg.io/4326
// -85.0511 <= latitude <= 85.0511
// -180.0 <= longitude <= 180.0

class LatLng {
  final double latitude;
  final double longitude;

  LatLng(this.latitude, this.longitude);

  LatLng.fromJson(Map<String, dynamic> json)
      : latitude = double.parse(json['latitude']),
        longitude = double.parse(json['longitude']);

  int get hashCode => latitude.hashCode + longitude.hashCode;

  @override
  bool operator ==(Object other) => other is LatLng && latitude == other.latitude && longitude == other.longitude;

  @override
  String toString() => 'LatLng($latitude, $longitude)';
}
