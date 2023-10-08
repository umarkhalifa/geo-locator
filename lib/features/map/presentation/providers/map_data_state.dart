import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:land2/features/map/domain/entity/location_point.dart';
import 'package:land2/utils/map_type.dart';


class MapDataState {
  final double latitude;
  final double longitude;
  final MyMapType mapType;
  final Set<Marker> markers;
  final Set<Marker>? firebaseMarkers;
  final bool isLoading;
  final bool showCompass;
  final List<LocationPoint>? points;
  final List<LocationPoint>? searchPoints;
  final List<LocationPoint>? firebasePoints;
  final List<LatLng>? polyPoints;

  MapDataState(this.latitude, this.longitude, this.mapType, this.markers,this.firebaseMarkers,
      this.isLoading, this.showCompass, this.points,this.searchPoints,this.firebasePoints,this.polyPoints, );

  MapDataState.initial({
    this.longitude = 0.0,
    this.latitude = 0.0,
    this.mapType = MyMapType.normal,
    this.markers = const {},
    this.firebaseMarkers = const {},
    this.isLoading = false,
    this.showCompass = false,
    this.points = const [],
    this.searchPoints = const [],
    this.firebasePoints = const [],
    this.polyPoints = const [],
  });

  MapDataState copyWith({
    double? latitude,
    double? longitude,
    MyMapType? mapType,
    Set<Marker>? markers,
    Set<Marker>? firebaseMarkers,
    bool? isLoading,
    bool? showCompass,
    List<LocationPoint>? points,
    List<LocationPoint>? searchPoints,
    List<LocationPoint>? firebasePoints,
    List<LatLng>? polyPoints,
  }) {
    return MapDataState(
        latitude ?? this.latitude,
        longitude ?? this.longitude,
        mapType ?? this.mapType,
        markers ?? this.markers,
        firebaseMarkers ?? this.firebaseMarkers,
        isLoading ?? this.isLoading,
        showCompass ?? this.showCompass,
        points ?? this.points,
        searchPoints ?? this.searchPoints,
        firebasePoints ?? this.firebasePoints,
        polyPoints ?? this.polyPoints);
  }
}

class MarkersState {
  final Set<Marker> markers;
  final bool isLoading;

  MarkersState(this.markers, this.isLoading);

  MarkersState.initial({
    this.markers = const {},
    this.isLoading = false,
  });

  MarkersState copyWith({Set<Marker>? markers, bool? isLoading}) {
    return MarkersState(
      markers ?? this.markers,
      isLoading ?? this.isLoading,
    );
  }
}