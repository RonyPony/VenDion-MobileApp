import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vendion/config/app_constants.dart';
import 'package:vendion/helpers/string_extensions.dart';
import 'package:vendion/l10n/app_localizations.dart';
import 'package:vendion/models/user_response.dart';
import 'package:vendion/models/vehicle_photo.dart';
import 'package:vendion/models/vehicles.dart';
import 'package:vendion/providers/auth_provider.dart';
import 'package:vendion/providers/messages_provider.dart';
import 'package:vendion/providers/vehicles_provider.dart';
import 'package:vendion/screens/chat_screen.dart';
import 'package:vendion/screens/sell_vehicle.dart';

import '../widgets/main_button_widget.dart';
import '../widgets/vehicle_image.dart';
import 'home_screen.dart';

class VehicleDetails extends StatefulWidget {
  static String routeName = "/vehicleDetails";

  const VehicleDetails({super.key});

  @override
  State<VehicleDetails> createState() => _VehicleDetailsState();
}

class _VehicleDetailsState extends State<VehicleDetails> {
  final ValueNotifier<String?> _selectedImage = ValueNotifier<String?>(null);

  Vehicle _carInfo = Vehicle();
  Future<VehiclePhoto>? _mainPhotoFuture;
  Future<List<VehiclePhoto>>? _galleryFuture;
  Future<UserResponse>? _currentUserFuture;
  bool _isInitialized = false;
  bool _isFavorite = false;
  bool _favoriteLoaded = false;
  bool _favoriteBusy = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments! as Vehicle;

    if (_isInitialized && _carInfo.id == args.id) {
      return;
    }

    _carInfo = args;
    final vehiclesProvider =
        Provider.of<VehiclesProvider>(context, listen: false);
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);

    _mainPhotoFuture = vehiclesProvider.getVechiclePhoto(_carInfo.id!);
    _galleryFuture = vehiclesProvider.getVechicleGallery(_carInfo.id!);
    _currentUserFuture = authProvider.getCurrentUser();
    _selectedImage.value = null;
    _isInitialized = true;
    _loadFavoriteState();
  }

  @override
  void dispose() {
    _selectedImage.dispose();
    super.dispose();
  }

  Future<void> _loadFavoriteState() async {
    final vehiclesProvider =
        Provider.of<VehiclesProvider>(context, listen: false);
    try {
      final user = await _currentUserFuture;
      if (user?.id == null || _carInfo.id == null) {
        return;
      }
      final result = await vehiclesProvider.isFavorite(_carInfo.id!, user!.id!);
      if (!mounted) {
        return;
      }
      setState(() {
        _isFavorite = result;
        _favoriteLoaded = true;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _favoriteLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: context.l10n.t('share'),
            icon: const Icon(Icons.share_rounded),
            onPressed: _shareVehicle,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGallery(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          (_carInfo.name ?? context.l10n.t('noData'))
                              .capitalize(),
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Icon(
                        _isFavorite
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'US ${_carInfo.price ?? 0}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            _buildDescription(),
            _buildFeatures(),
            _buildOptions(_carInfo.location ?? context.l10n.t('noData')),
            _buildFavoriteButton(),
            _buildChatButton(),
            _buildPrimaryAction(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildGallery() {
    return FutureBuilder<VehiclePhoto>(
      future: _mainPhotoFuture,
      builder: (context, snapshot) {
        final fallbackImage = snapshot.data?.image;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: ValueListenableBuilder<String?>(
                valueListenable: _selectedImage,
                builder: (context, selectedImage, child) {
                  final image = selectedImage ?? fallbackImage;

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return VehicleImagePlaceholder(
                      width: MediaQuery.of(context).size.width * .95,
                      height: MediaQuery.of(context).size.width * .76,
                      borderRadius: AppRadius.lg,
                      loading: true,
                    );
                  }

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    child: VehicleImage(
                      key: ValueKey(image ?? 'empty'),
                      base64Image: image,
                      width: MediaQuery.of(context).size.width * .95,
                      height: MediaQuery.of(context).size.width * .76,
                      borderRadius: AppRadius.lg,
                    ),
                  );
                },
              ),
            ),
            _buildThumbnails(),
          ],
        );
      },
    );
  }

  Widget _buildThumbnails() {
    return FutureBuilder<List<VehiclePhoto>>(
      future: _galleryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 4,
            child: LinearProgressIndicator(color: AppColors.primary),
          );
        }

        final photos = snapshot.data ?? [];
        if (snapshot.hasError || photos.length < 2) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: 76,
          child: ValueListenableBuilder<String?>(
            valueListenable: _selectedImage,
            builder: (context, selectedImage, child) {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                scrollDirection: Axis.horizontal,
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  final image = photos[index].image;
                  final selected = selectedImage == image ||
                      (selectedImage == null &&
                          index == 0 &&
                          image != null &&
                          image.isNotEmpty);

                  return GestureDetector(
                    onTap: () {
                      _selectedImage.value = image;
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 86,
                      margin: const EdgeInsets.only(right: AppSpacing.sm),
                      padding: EdgeInsets.all(selected ? 3 : 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color:
                              selected ? AppColors.primary : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: VehicleImage(
                        base64Image: image,
                        width: 82,
                        height: 64,
                        borderRadius: AppRadius.md,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDescription() {
    final description = _carInfo.description ?? context.l10n.t('noData');

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.4),
          ),
          if (description.length >= 100)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text(
                context.l10n.t('readMore'),
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFeatures() {
    final features = (_carInfo.features ?? '')
        .split(',')
        .map(
            (feature) => feature.replaceAll('[', '').replaceAll(']', '').trim())
        .where((feature) => feature.isNotEmpty)
        .toList();

    if (features.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
      child: SizedBox(
        height: 42,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: features.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: Chip(
                backgroundColor: AppColors.primary,
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_box_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      features[index],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOptions(String location) {
    final items = [
      _InfoItem(Icons.handshake_rounded, context.l10n.t('contactDealer')),
      _InfoItem(Icons.car_rental, context.l10n.t('vehicleDetails')),
      _InfoItem(Icons.location_on, location),
      _InfoItem(Icons.attach_money, context.l10n.t('financingAvailable')),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.sm,
        children: items
            .map(
              (item) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(item.icon, size: 18, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.xs),
                  Text(item.label),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    if (!_favoriteLoaded) {
      return const Padding(
        padding: EdgeInsets.only(top: 20),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          foregroundColor: _isFavorite ? Colors.white : AppColors.primary,
          backgroundColor: _isFavorite ? AppColors.primary : Colors.transparent,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
        onPressed: _favoriteBusy ? null : _toggleFavorite,
        icon:
            Icon(_isFavorite ? Icons.star_rounded : Icons.star_border_rounded),
        label: Text(
          _favoriteBusy
              ? context.l10n.t('updating')
              : _isFavorite
                  ? context.l10n.t('removeFromFavorites')
                  : context.l10n.t('addToFavorites'),
        ),
      ),
    );
  }

  Widget _buildChatButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 54),
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
        onPressed: _openSellerChat,
        icon: const Icon(Icons.forum_rounded),
        label: Text(context.l10n.t('chatWithSeller')),
      ),
    );
  }

  Widget _buildPrimaryAction() {
    return FutureBuilder<UserResponse>(
      future: _currentUserFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.only(top: 30),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(context.l10n.t('currentUserError')),
          );
        }

        final isOwner = _carInfo.createdBy == snapshot.data?.id;
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: CustomBtn(
            mainBtn: true,
            onTap: () {
              if (isOwner) {
                Navigator.pushNamed(
                  context,
                  SellScreen.routeName,
                  arguments: _carInfo.id,
                );
              } else {
                Navigator.pushNamedAndRemoveUntil(
                    context, HomeScreen.routeName, (route) => false);
              }
            },
            enable: true,
            text: isOwner
                ? context.l10n.t('editVehicle')
                : context.l10n.t('interested'),
          ),
        );
      },
    );
  }

  Future<void> _toggleFavorite() async {
    final vehiclesProvider =
        Provider.of<VehiclesProvider>(context, listen: false);
    final previous = _isFavorite;
    setState(() {
      _isFavorite = !previous;
      _favoriteBusy = true;
    });

    try {
      final user = await _currentUserFuture;
      if (user?.id == null || _carInfo.id == null) {
        throw Exception('Missing user or vehicle');
      }

      final success = previous
          ? await vehiclesProvider.removeFromFavorite(_carInfo.id!, user!.id!)
          : await vehiclesProvider.addToFavorite(_carInfo.id!, user!.id!);

      if (!success) {
        throw Exception('Favorite update failed');
      }

      _carInfo.isFavorite = !previous;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.t('favoriteUpdated'))),
        );
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isFavorite = previous;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.t('favoriteError'))),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _favoriteBusy = false;
        });
      }
    }
  }

  Future<void> _shareVehicle() async {
    final title = _carInfo.name ?? context.l10n.t('vehicleDetails');
    final price = _carInfo.price != null ? 'US ${_carInfo.price}' : '';
    final id = _carInfo.id != null ? '#${_carInfo.id}' : '';
    final text = [
      context.l10n.t('shareVehicle'),
      title,
      if (price.isNotEmpty) price,
      if (id.isNotEmpty) id,
    ].join('\n');

    await SharePlus.instance.share(
      ShareParams(text: text, subject: title),
    );
  }

  Future<void> _openSellerChat() async {
    final messagesProvider =
        Provider.of<MessagesProvider>(context, listen: false);
    final conversation = await messagesProvider.openForVehicle(_carInfo);
    if (!mounted) {
      return;
    }
    Navigator.pushNamed(
      context,
      ChatScreen.routeName,
      arguments: conversation.id,
    );
  }
}

class _InfoItem {
  const _InfoItem(this.icon, this.label);

  final IconData icon;
  final String label;
}
