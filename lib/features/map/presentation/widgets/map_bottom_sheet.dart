import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:land2/core/constants/sizes.dart';
import 'package:land2/features/map/presentation/providers/get_point_provider.dart';
import 'package:land2/features/map/presentation/widgets/location_card.dart';
import 'package:land2/features/map/presentation/widgets/map_type_widgets.dart';
import 'package:land2/features/map/presentation/widgets/utm_coordinates_widgets.dart';
import 'package:solar_icons/solar_icons.dart';

class LandBottomSheet extends HookConsumerWidget {
  final Future<void> Function(double lat, double long) locationFuture;

  const LandBottomSheet({
    super.key,
    required this.locationFuture,
  });

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25),
            topLeft: Radius.circular(25),
          ),
        ),
        padding: EdgeInsets.only(
            left: 25,
            right: 25,
            top: 25,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: RefreshIndicator(
          onRefresh: ()async{
            ref.read(getPointsProvider.notifier).getPoints();
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                gapH12,
                Row(
                  children: [
                    const Spacer(),
                    const Text(
                      "Navigation Tools",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(SolarIconsOutline.closeSquare),
                    ),
                  ],
                ),
                gapH12,
                const Divider(
                  thickness: 0.4,
                ),
                const MapTypeIcon(),
                const Divider(
                  thickness: 0.4,
                ),
                CalculateUtmIcon(
                  locationFuture: locationFuture,
                ),
                const Divider(
                  thickness: 0.4,
                ),
                LocationCard(
                    locationFuture: locationFuture),
                const Divider(
                  thickness: 0.4,
                ),
                const LogoutIcon(),
                gapH20,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LogoutIcon extends StatelessWidget {
  const LogoutIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FirebaseAuth.instance.signOut(),
      child: Row(
        children: [
          const SizedBox(
            height: 45,
            width: 45,
            child: Icon(
              SolarIconsOutline.logout_2,
              color: Colors.red,
              size: 30,
            ),
          ),
          gapW20,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Logout",
                style: TextStyle(
                    fontWeight: FontWeight.w500, fontSize: 16, height: 1),
              ),
              Text(FirebaseAuth.instance.currentUser?.email ?? '')
            ],
          ),
        ],
      ),
    );
  }
}
