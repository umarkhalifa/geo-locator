import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:land2/features/map/domain/entity/location_point.dart';

class MapFirestoreData {
  final FirebaseFirestore _firestore;

  MapFirestoreData(this._firestore,);


  Future<List<LocationPoint>> watchPoint() async {
    final value = await _firestore.collection('POINTS').get();
    return value.docs.map((document) {
      double latitude = document.data()['latitude'] ?? 0.0;
      double longitude = document.data()['longitude'] ?? 0.0;
      double northing = document.data()['northing'] ?? 0.0;
      double easting = document.data()['easting'] ?? 0.0;
      int zone = document.data()['zone'] ?? 0;
      String band = document.data()['band'] ?? '';
      String name = document.data()['name'] ?? '';
      double height = document.data()['height'];
      return LocationPoint(latitude: latitude,
          longitude: longitude,
          northing: northing,
          easting: easting,
          zone: zone,
          band: band,
          name: name,
          height: height);
    }).toList();
  }


}

final firestoreDataProvider = Provider((ref) {
  return MapFirestoreData(FirebaseFirestore.instance);
});
