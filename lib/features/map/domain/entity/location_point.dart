import 'package:hive/hive.dart';

part 'location_point.g.dart';

@HiveType(typeId: 1)
class LocationPoint {
  LocationPoint(
      {required this.latitude,
        required this.longitude,
        required this.northing,
        required this.easting,
        required this.zone,
        required this.band,
        required this.name,
        required this.height});

  @HiveField(0)
  double latitude;

  @HiveField(1)
  double longitude;

  @HiveField(2)
  double northing;

  @HiveField(3)
  double easting;

  @HiveField(4)
  int zone;

  @HiveField(5)
  String band;

  @HiveField(6)
  String name;

  @HiveField(7)
  double height;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationPoint &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          northing == other.northing &&
          easting == other.easting &&
          zone == other.zone &&
          band == other.band &&
          name == other.name &&
          height == other.height;

  @override
  int get hashCode =>
      latitude.hashCode ^
      longitude.hashCode ^
      northing.hashCode ^
      easting.hashCode ^
      zone.hashCode ^
      band.hashCode ^
      name.hashCode ^
      height.hashCode;
}
