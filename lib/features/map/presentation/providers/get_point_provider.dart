import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:land2/features/map/domain/entity/location_point.dart';
import 'package:land2/features/map/domain/usecases/get_points_usecase.dart';
import 'package:land2/features/map/presentation/providers/map_data_state.dart';
import 'package:land2/features/map/presentation/providers/map_state_provider.dart';
import 'package:land2/features/map/presentation/widgets/land_map.dart';

import '../../domain/usecases/get_firestore_points.dart';

class GetPointsNotifier extends StateNotifier<MapDataState> {
  GetPointsNotifier(
      this._getPointUseCase, this._getFireStorePointUseCase, this.ref)
      : super(MapDataState.initial()) {
    init();
  }

  final GetPointUseCase _getPointUseCase;
  final GetFirestorePointUseCase _getFireStorePointUseCase;
  final Ref ref;

  Future<void> init() async {
    await getLocalPoints();
    await getPoints();

  }

  Future<void> getLocalPoints() async {
    state = state.copyWith(isLoading: true);
    final value = await _getPointUseCase.call(null);
    state = value.fold((l) {
      return state.copyWith(isLoading: false);
    }, (r) {
      final Set<Marker> markers = {};
      for (LocationPoint point in r) {
        markers.add(
          Marker(
              markerId: MarkerId('${point.latitude}'),
              position: LatLng(point.latitude, point.longitude),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueCyan),
              onTap: () {
                if (ref.read(mapNotifierProvider).showCompass) {
                  ref.read(markerIndex.notifier).state = r.indexOf(point);
                } else {
                  ref.read(mapNotifierProvider.notifier).updateCompass(true);
                  ref.read(markerIndex.notifier).state = r.indexOf(point);
                }
              }),
        );
      }
      return state.copyWith(
          isLoading: false,
          markers: markers,
          points: [...r,...state.firebasePoints!],
          searchPoints: [...r,...state.firebasePoints!]);
    });
  }

  Future<void> getPoints() async {
    state = state.copyWith(isLoading: true);
    final value = await _getFireStorePointUseCase.call(null);
    final icon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(5, 5), devicePixelRatio: 0.2),
        "assets/images/pin.png");
    state = value.fold((l) {
      return state = state.copyWith(isLoading: false);
    }, (r) {
      final Set<Marker> markers = {};
      for (LocationPoint point in r) {

        markers.add(
          Marker(
              markerId: MarkerId('${point.latitude}'),
              position: LatLng(point.latitude, point.longitude),
              icon: icon,
              onTap: () {
                if (ref.read(mapNotifierProvider).showCompass) {
                  ref.read(markerIndex.notifier).state = r.indexOf(point);
                } else {
                  ref.read(mapNotifierProvider.notifier).updateCompass(true);
                  ref.read(markerIndex.notifier).state = r.indexOf(point);
                }
              }
          ),
        );
      }
// Convert the lists to sets to remove duplicates
      Set<LocationPoint> set1 = Set<LocationPoint>.from(state.searchPoints!);
      Set<LocationPoint> set2 = Set<LocationPoint>.from(r);

// Perform the union operation to combine the sets
      Set<LocationPoint> combinedSet = set1.union(set2);

// Convert the result back to a list
      List<LocationPoint> combinedList = combinedSet.toList();

      return state = state.copyWith(
          firebaseMarkers: markers,
          searchPoints: combinedList,
          points: combinedList,
          firebasePoints: r);
    });

  }

  void searchPoints(String name) {
    if (name == '') {
      state = state.copyWith(searchPoints: state.points);
    } else {
      final points = state.points!.where((element) {
        return element.name.contains(name);
      }).toList();
      state = state.copyWith(searchPoints: points);
    }
  }

  void resetSearch() {
    state = state.copyWith(searchPoints: state.points);
  }
}

final getPointsProvider =
    StateNotifierProvider<GetPointsNotifier, MapDataState>((ref) {
  final useCase = ref.read(getPointsUseCaseProvider);
  final firesStore = ref.read(getFirestorePointsUseCaseProvider);
  return GetPointsNotifier(useCase, firesStore, ref);
});
