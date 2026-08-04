import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vendion/config/app_constants.dart';
import 'package:vendion/helpers/string_extensions.dart';
import 'package:vendion/l10n/app_localizations.dart';
import 'package:vendion/models/vehicle_photo.dart';
import 'package:vendion/providers/auth_provider.dart';
import 'package:vendion/providers/vehicles_provider.dart';
import 'package:vendion/screens/car_details_screen.dart';
import 'package:vendion/screens/filters_screen.dart';
import 'package:vendion/widgets/bottom_menu.dart';
import 'package:vendion/widgets/carrousel.dart';
import 'package:vendion/widgets/drawer.dart';
import 'package:vendion/widgets/notification_button.dart';
import 'package:vendion/widgets/vehicle_image.dart';

import '../models/vehicles.dart';
import '../widgets/main_button_widget.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/homeScreen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSearching = false;

  bool isSearchingLoading = false;
  late final Future<List<Vehicle>> _offersFuture;
  late final Future<List<Vehicle>> _recommendedVehiclesFuture;

  @override
  void initState() {
    super.initState();
    final vehicleProvider =
        Provider.of<VehiclesProvider>(context, listen: false);
    _offersFuture = vehicleProvider.getAllOfferVehicle();
    _recommendedVehiclesFuture = _loadRecommendedVehicles(vehicleProvider);
  }

  Future<List<Vehicle>> _loadRecommendedVehicles(
    VehiclesProvider vehicleProvider,
  ) async {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    final user = await authProvider.getCurrentUser();
    return vehicleProvider.getAllAvailableVehicles(user.id ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: GeneralDrawer(),
        // bottomNavigationBar: BottomMenu(),
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height * .1,
          actions: const [NotificationButton()],
          title: const Text(
            "VenDion",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xffff5b00),
              fontSize: 24,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  _buildSearchSection(),
                  _buildCarrouser(),
                  _buildRecommendedSection(
                      MediaQuery.of(context).size.width * .30),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .15,
                  )
                ],
              ),
            ),
            BottomMenu(
              currentIndex: 0,
            ),
          ],
        ));
  }

  Widget _buildRecommendedSection(double ancho) {
    final vehicleProvider =
        Provider.of<VehiclesProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                context.l10n.t('recommended'),
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontSize: 20,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: ancho,
              ),
              Opacity(
                opacity: 0.40,
                child: Text(
                  context.l10n.t('seeAll'),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    fontSize: 16,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
          FutureBuilder<List<Vehicle>>(
            future: _recommendedVehiclesFuture,
            builder: (context, vehicleListSnapshot) {
              if (vehicleListSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return CircularProgressIndicator(color: Color(0xffff5b00));
              }
              if (vehicleListSnapshot.hasError) {
                return Text(context.l10n.t('error'));
              }
              if (vehicleListSnapshot.hasData &&
                  vehicleListSnapshot.connectionState == ConnectionState.done) {
                // return Text(snapshot.data![0].name!);
                return ListView.builder(
                  shrinkWrap: true,
                  // primary: true,
                  // physics:  ClampingScrollPhysics(),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: vehicleListSnapshot.data!.length,
                  itemBuilder: (context, index) {
                    Vehicle project = vehicleListSnapshot.data![index];
                    if (!project.isOffer!) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: _buildaRecommended(project, vehicleProvider),
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                );
              }

              return Text(context.l10n.t('noData'));
            },
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 15, top: 20),
          //   child: SingleChildScrollView(
          //     scrollDirection: Axis.horizontal,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         _buildaRecommended(true, true, "Audi Q7 Sport", "US. 23,000"),
          //         _buildaRecommended(
          //             false, true, "Audi Q7 Sport", "US. 23,000"),
          //       ],
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 15, top: 20),
          //   child: SingleChildScrollView(
          //     scrollDirection: Axis.horizontal,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         _buildaRecommended(true, true, "Audi Q7 Sport", "US. 23,000"),
          //         _buildaRecommended(
          //             false, true, "Audi Q7 Sport", "US. 23,000"),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  _buildSearchSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 65,
              width: MediaQuery.of(context).size.width * .8,
              decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xff1d1d24)
                      : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(10)),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 10),
                      child: SvgPicture.asset("assets/search.svg"),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * .07,
                      width: MediaQuery.of(context).size.width * .65,
                      child: TextField(
                        onChanged: (value) {
                          final nextIsSearching = value.isNotEmpty;
                          if (nextIsSearching != isSearching) {
                            setState(() {
                              isSearching = nextIsSearching;
                            });
                          }
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(20)),
                            hintText: context.l10n.t('searchHint')),
                      ),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, FiltersScreen.routeName);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: SvgPicture.asset("assets/filter.svg"),
              ),
            )
          ],
        ),
        isSearching ? _buildSearchBtn() : SizedBox()
      ],
    );
  }

  _buildSearchBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.routeName, (route) => false);
        },
        child: CustomBtn(
          mainBtn: true,
          enable: !isSearchingLoading,
          loadingText: context.l10n.t('searching'),
          onTap: () {
            setState(() {
              isSearchingLoading = true;
            });
          },
          text: context.l10n.t('search'),
        ),
      ),
    );
  }

  _buildCarrouser() {
    return FutureBuilder<List<Vehicle>>(
      future: _offersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LinearProgressIndicator(
            color: Color(0xffff5b00),
            backgroundColor: Colors.white,
          );
        }
        if (snapshot.hasError) {
          return Text(context.l10n.t('error'));
        }
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          return Padding(
            padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
            child: Carrousel(snapshot.data!),
          );
        }

        return Text(context.l10n.t('noContent'));
      },
    );
  }

  _buildaRecommended(Vehicle vehicle, VehiclesProvider provider) {
    bool hasVideo = true;
    bool liked = vehicle.isFavorite ?? false;
    Future<VehiclePhoto> _carPhoto = provider.getVechiclePhoto(vehicle.id!);

    return Container(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * .04,
          right: MediaQuery.of(context).size.width * .04),
      // color: Colors.red.withOpacity(.5),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, VehicleDetails.routeName,
              arguments: vehicle);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                VehiclePhotoFutureImage(
                  future: _carPhoto,
                  height: 200,
                  borderRadius: 24,
                ),
                if (hasVideo)
                  Positioned(
                    bottom: 12,
                    left: 14,
                    child: Image.asset("assets/video.png"),
                  ),
                Positioned(
                  top: 10,
                  right: 14,
                  child: GestureDetector(
                    onTap: () async {
                      await _toggleFavorite(vehicle, provider);
                    },
                    child: SvgPicture.asset(
                      (vehicle.isFavorite ?? liked)
                          ? "assets/liked.svg"
                          : "assets/notliked.svg",
                      width: 28,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: SizedBox(
                width: 174,
                child: Text(
                  vehicle.name!.capitalize(),
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: 18,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Opacity(
                opacity: 0.50,
                child: Text(
                  "${context.l10n.t('price')}: ${vehicle.price.toString()}  |  ${context.l10n.t('year')}: ${vehicle.year}",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    fontSize: 12,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _toggleFavorite(
    Vehicle vehicle,
    VehiclesProvider provider,
  ) async {
    final previous = vehicle.isFavorite ?? false;
    setState(() {
      vehicle.isFavorite = !previous;
    });

    try {
      final authProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);
      final user = await authProvider.getCurrentUser();
      if (vehicle.id == null || user.id == null) {
        throw Exception('Missing favorite data');
      }

      final success = previous
          ? await provider.removeFromFavorite(vehicle.id!, user.id!)
          : await provider.addToFavorite(vehicle.id!, user.id!);

      if (!success) {
        throw Exception('Favorite update failed');
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        vehicle.isFavorite = previous;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.t('favoriteError'))),
      );
    }
  }
}
