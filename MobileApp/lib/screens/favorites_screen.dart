import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendion/config/app_constants.dart';
import 'package:vendion/l10n/app_localizations.dart';
import 'package:vendion/models/vehicles.dart';
import 'package:vendion/providers/auth_provider.dart';
import 'package:vendion/providers/vehicles_provider.dart';
import 'package:vendion/widgets/bottom_menu.dart';
import 'package:vendion/widgets/drawer.dart';
import 'package:vendion/widgets/notification_button.dart';
import 'package:vendion/widgets/search_section.dart';
import 'package:vendion/widgets/vehicle_image.dart';

import 'car_details_screen.dart';

class FavoriteScreen extends StatefulWidget {
  static String routeName = "/favoriteScreen";

  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _StateFavoriteScreen();
}

class _StateFavoriteScreen extends State<FavoriteScreen> {
  late Future<List<Vehicle>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = _loadFavoriteVehicles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const GeneralDrawer(),
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * .1,
        actions: const [NotificationButton()],
        title: Text(
          context.l10n.t('appName'),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 24,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshFavorites,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildSearchSection()),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                    child: Text(
                      context.l10n.t('favorites'),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ),
                FutureBuilder<List<Vehicle>>(
                  future: _favoritesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: CircularProgressIndicator(
                              color: AppColors.primary),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: _FavoritesState(
                          icon: Icons.error_outline_rounded,
                          text: context.l10n.t('error'),
                          actionText: context.l10n.t('retry'),
                          onPressed: _reloadFavorites,
                        ),
                      );
                    }

                    final vehicles = snapshot.data ?? [];
                    if (vehicles.isEmpty) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: _FavoritesState(
                          icon: Icons.star_rounded,
                          text: context.l10n.t('noFavorites'),
                        ),
                      );
                    }

                    return SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
                      sliver: SliverList.separated(
                        itemCount: vehicles.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: AppSpacing.lg),
                        itemBuilder: (context, index) {
                          return _FavoriteVehicleCard(
                            vehicle: vehicles[index],
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                VehicleDetails.routeName,
                                arguments: vehicles[index],
                              ).then((_) => _reloadFavorites());
                            },
                            onRemove: () => _removeFavorite(vehicles[index]),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const BottomMenu(currentIndex: 1),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return SearchSection();
  }

  Future<List<Vehicle>> _loadFavoriteVehicles() async {
    final vehicleProvider =
        Provider.of<VehiclesProvider>(context, listen: false);
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    final user = await authProvider.getCurrentUser();
    if (user.id == null) {
      return [];
    }

    final favorites = await vehicleProvider.getAllFavoriteVehicles(user.id!);
    final seenVehicleIds = <int>{};
    final vehicles = <Vehicle>[];

    for (final favorite in favorites) {
      final vehicleId = favorite.vehicleId;
      if (vehicleId == null || !seenVehicleIds.add(vehicleId)) {
        continue;
      }
      final vehicle = await vehicleProvider.getVehicleInfo(vehicleId);
      vehicle.isFavorite = true;
      vehicles.add(vehicle);
    }

    return vehicles;
  }

  Future<void> _refreshFavorites() async {
    _reloadFavorites();
    await _favoritesFuture;
  }

  void _reloadFavorites() {
    if (!mounted) {
      return;
    }
    setState(() {
      _favoritesFuture = _loadFavoriteVehicles();
    });
  }

  Future<void> _removeFavorite(Vehicle vehicle) async {
    try {
      final vehicleProvider =
          Provider.of<VehiclesProvider>(context, listen: false);
      final authProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);
      final user = await authProvider.getCurrentUser();
      if (vehicle.id == null || user.id == null) {
        throw Exception('Missing favorite data');
      }

      final success =
          await vehicleProvider.removeFromFavorite(vehicle.id!, user.id!);
      if (!success) {
        throw Exception('Favorite remove failed');
      }

      _reloadFavorites();
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.t('favoriteError'))),
      );
    }
  }
}

class _FavoriteVehicleCard extends StatelessWidget {
  const _FavoriteVehicleCard({
    required this.vehicle,
    required this.onTap,
    required this.onRemove,
  });

  final Vehicle vehicle;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VehiclesProvider>(context, listen: false);
    final theme = Theme.of(context);

    return Material(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  VehiclePhotoFutureImage(
                    future: provider.getVechiclePhoto(vehicle.id ?? 0),
                    height: 200,
                    borderRadius: AppRadius.lg,
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: theme.cardColor.withValues(alpha: .92),
                        foregroundColor: AppColors.primary,
                      ),
                      tooltip: context.l10n.t('removeFromFavorites'),
                      onPressed: onRemove,
                      icon: const Icon(Icons.star_rounded),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                child: Text(
                  (vehicle.name ?? context.l10n.t('noData')).toUpperCase(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                child: Opacity(
                  opacity: 0.72,
                  child: Text(
                    "${context.l10n.t('price')}: ${vehicle.price ?? 0}  |  ${context.l10n.t('year')}: ${vehicle.year ?? context.l10n.t('noData')}",
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _FavoritesState extends StatelessWidget {
  const _FavoritesState({
    required this.icon,
    required this.text,
    this.actionText,
    this.onPressed,
  });

  final IconData icon;
  final String text;
  final String? actionText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 88,
              color: AppColors.primary.withValues(alpha: .5),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.primary.withValues(alpha: .72),
                    fontWeight: FontWeight.w700,
                  ),
            ),
            if (actionText != null) ...[
              const SizedBox(height: AppSpacing.md),
              OutlinedButton(
                onPressed: onPressed,
                child: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
