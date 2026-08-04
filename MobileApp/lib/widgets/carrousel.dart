import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendion/config/app_constants.dart';
import 'package:vendion/l10n/app_localizations.dart';
import 'package:vendion/models/vehicle_photo.dart';
import 'package:vendion/models/vehicles.dart';
import 'package:vendion/providers/vehicles_provider.dart';
import 'package:vendion/screens/car_details_screen.dart';
import 'package:vendion/widgets/vehicle_image.dart';

class Carrousel extends StatelessWidget {
  const Carrousel(this.list, {Key? key}) : super(key: key);

  final List<Vehicle> list;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * .3;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: height,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) {
          final photoProvider =
              Provider.of<VehiclesProvider>(context, listen: false);
          final Future<VehiclePhoto> vehiclePhoto =
              photoProvider.getVechiclePhoto(list[index].id!);

          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                VehicleDetails.routeName,
                arguments: list[index],
              );
            },
            child: _OfferCard(
              future: vehiclePhoto,
              description: list[index].description ?? context.l10n.t('noData'),
            ),
          );
        },
      ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  const _OfferCard({
    required this.future,
    required this.description,
  });

  final Future<VehiclePhoto> future;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: AppSpacing.md),
      child: Stack(
        children: [
          VehiclePhotoFutureImage(
            future: future,
            height: MediaQuery.of(context).size.height * .26,
            width: 300,
            borderRadius: 20,
          ),
          Positioned(
            left: AppSpacing.sm,
            top: AppSpacing.md,
            child: Transform.rotate(
              angle: -0.65,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Text(
                  context.l10n.t('offer'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: AppSpacing.md,
            right: AppSpacing.md,
            bottom: AppSpacing.md,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.55),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
