import 'package:vagabond/models/latlng.dart';

class Shelter {
  final String id;
  final DateTime createdAt;
  final String name;
  final LatLng location;
  final bool opened;
  final String? coverUrl;
  final String? description;

  Shelter({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.location,
    this.opened = true,
    this.coverUrl,
    this.description,
  });

  Shelter.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        createdAt = DateTime.parse(json['created_at']),
        location = LatLng(json['latitude'].toDouble(), json['longitude'].toDouble()),
        coverUrl = json['cover_url'],
        opened = json['opened'] ?? true,
        description = json['description'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_at': createdAt.toIso8601String(),
        'name': name,
        'latitude': location.latitude,
        'longitude': location.longitude,
        'opened': opened,
        'cover_url': coverUrl,
        'description': description,
      };
}
