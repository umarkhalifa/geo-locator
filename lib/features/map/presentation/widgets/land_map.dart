import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:land2/features/map/presentation/providers/get_point_provider.dart';
import 'package:land2/features/map/presentation/widgets/distance_card.dart';
import 'package:land2/features/map/presentation/widgets/map_bottom_sheet.dart';
import 'package:land2/features/map/presentation/widgets/navigation_widget.dart';
import 'package:land2/features/map/presentation/widgets/save_points_dialog.dart';
import 'package:land2/utils/map_type.dart';
import 'package:solar_icons/solar_icons.dart';

import '../providers/calculate_utm_provider.dart';
import '../providers/map_data_state.dart';
import '../providers/map_state_provider.dart';

final markerIndex = StateProvider<int>((ref) => 0);

class LandMap extends ConsumerStatefulWidget {
  const LandMap({
    super.key,
    required this.mapState,
  });

  final MapDataState mapState;

  @override
  ConsumerState<LandMap> createState() => _LandMapState();
}

class _LandMapState extends ConsumerState<LandMap> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    final pointState = ref.watch(getPointsProvider);
    bool showCompass = widget.mapState.showCompass;
    final markers = pointState.firebaseMarkers!.union(pointState.markers);
     return SafeArea(
       child: Stack(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            child: GoogleMap(
              myLocationEnabled: true,
              mapType: widget.mapState.mapType.toType(),
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  widget.mapState.latitude,
                  widget.mapState.longitude,
                ),
                zoom: 15,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: markers,
              onTap: (value){
                ref.read(mapNotifierProvider.notifier).updateCompass(false);
              },
            ),
          ),
          if (markers.isNotEmpty && showCompass)
            DistanceCard(locationFuture: _updateMap,
            ),
          NavigationWidget(
            changeColor: widget.mapState.mapType == MyMapType.normal,
          ),
          Positioned(
            top: 70,
            right: 15,
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(20),
              child: GestureDetector(
                onTap: () async {
                  await showModalBottomSheet(
                      context: context,
                      builder: (context) => LandBottomSheet(
                        locationFuture: _updateMap,
                      ),
                      isScrollControlled: true,useSafeArea: true).then((value) => ref.read(getPointsProvider.notifier).resetSearch());
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    SolarIconsOutline.menuDots,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 120,
            right: 15,
            child: Visibility(
              visible: ref.watch(calculateUtmNotifierProvider).showButton ??
                  true,
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(20),
                child: GestureDetector(
                  onTap: () async {
                    await showDialog(
                        context: context,
                        builder: (context) => const SavePointDialog());
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      SolarIconsOutline.mapPoint,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
    ),
     );
  }

  Future<void> _updateMap(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newLatLng(LatLng(lat, long)));
  }
}

