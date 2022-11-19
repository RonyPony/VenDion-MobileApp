import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vendion/models/favorites.dart';
import 'package:vendion/models/user_response.dart';
import 'package:vendion/providers/auth_provider.dart';
import 'package:vendion/providers/vehicles_provider.dart';
import 'package:vendion/widgets/drawer.dart';

import '../models/vehicle_photo.dart';
import '../models/vehicles.dart';
import '../widgets/bottom_menu.dart';
import '../widgets/search_section.dart';
import 'car_details_screen.dart';
import 'filters_screen.dart';
import 'notifications_screen.dart';

class FavoriteScreen extends StatefulWidget {
  static String routeName = "/favoriteScreen";

  @override
  State<FavoriteScreen> createState() => _StateFavoriteScreen();
}

class _StateFavoriteScreen extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        drawer: GeneralDrawer(),
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height * .1,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, NotificationsScreen.routeName);
                  },
                  child: SvgPicture.asset("assets/notification-active.svg")),
            )
          ],
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchSection(),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 20, bottom: 20),
                    child: Text(
                      "Favoritos",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),

                  FutureBuilder<List<FavoriteVehicle>>(
                    future: _getAllFavorites(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Color(0xffff5b00),
                            ),
                          ],
                        );
                      }
                      if (snapshot.hasError) {
                        return Text("Error");
                      }
                      if (snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.done) {
                        return Container(
                          child: FutureBuilder<Widget>(
                            future: _buildaFavorite(snapshot.data!),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      color: Color(0xffff5b00),
                                    ),
                                  ],
                                );
                              }

                              if (snapshot.hasError) {
                                return Text("Err");
                              }

                              if (snapshot.hasData &&
                                  snapshot.connectionState ==
                                      ConnectionState.done) {
                                return snapshot.data!;
                              }
                              return Text("no data");
                            },
                          ),
                        );
                      }
                      return Text("no data");
                    },
                  ),
                  // Column(
                  //   children: [
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         _buildaFavorite(true, "name", "finalPrice"),
                  //         _buildaFavorite(true, "name", "finalPrice"),
                  //       ],
                  //     ),
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         _buildaFavorite(true, "name", "finalPrice"),
                  //         _buildaFavorite(true, "name", "finalPrice"),
                  //       ],
                  //     ),
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         _buildaFavorite(true, "name", "finalPrice"),
                  //         _buildaFavorite(true, "name", "finalPrice"),
                  //       ],
                  //     ),
                  //     SizedBox(height: 100,)
                  //   ],
                  // )
                ],
              ),
            ),
            BottomMenu(
              currentIndex: 1,
            ),
          ],
        ));
  }

  Future<Widget> _buildaFavorite(List<FavoriteVehicle> vehi) async {
    final provider = Provider.of<VehiclesProvider>(context, listen: false);
    List<Vehicle> vehiclesList = [];
    for (FavoriteVehicle item in vehi) {
      Vehicle vehicle = await provider.getVehicleInfo(item.vehicleId!);
      vehiclesList.add(vehicle);
    }

    bool hasVideo = true;
    if (vehiclesList.length == 0) {
      return Padding(
        padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height/4.5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star_rounded,size: 95,color: Color(0xffff5b00).withOpacity(.5),),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("No has agregado nada a favoritos",style: TextStyle(fontSize: 20,color: Color(0xffff5b00).withOpacity(.5)),),
              ],
            )
            
          ],
        ),
      );
    }

    return Container(
      // color: Colors.red,
      height: MediaQuery.of(context).size.height * .62,
      child: ListView.builder(
        primary: true,
        itemCount: vehiclesList.length,
        itemBuilder: (context, index) {
          Future<VehiclePhoto> _carPhoto =
              provider.getVechiclePhoto(vehiclesList[index].id!);
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Container(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * .04,
                  right: MediaQuery.of(context).size.width * .04),
              // color: Colors.red.withOpacity(.5),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, VehicleDetails.routeName,
                      arguments: vehiclesList[index]);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<VehiclePhoto>(
                      future: _carPhoto,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: Color(0xffff5b00),
                              ),
                            ],
                          );
                        }
                        if (snapshot.hasError) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/placeholder.png",
                                scale: 3,
                              ),
                            ],
                          );
                        }
                        if (snapshot.hasData &&
                            snapshot.connectionState == ConnectionState.done) {
                          bool liked = true;
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: Image.memory(base64Decode(
                                              snapshot.data!.image!))
                                          .image,
                                    ),
                                  ),
                                ),
                              ),
                              hasVideo
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          top: 160, left: 15),
                                      child: Image.asset("assets/video.png"),
                                    )
                                  : SizedBox(),
                              liked
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                          top: 10,
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .75),
                                      child: GestureDetector(
                                          onTap: () {
                                            print(
                                                "Liked ${vehiclesList[index].name}");
                                          },
                                          child: SvgPicture.asset(
                                              "assets/liked.svg")),
                                    )
                                  : Padding(
                                      padding: EdgeInsets.only(
                                          top: 10,
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .75),
                                      child: SvgPicture.asset(
                                        "assets/notliked.svg",
                                        width: 26,
                                      ),
                                    )
                            ],
                          );
                        }
                        return Text("No data");
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 10),
                      child: SizedBox(
                        width: 174,
                        child: Text(
                          vehiclesList[index].name!.toUpperCase(),
                          style: TextStyle(
                            color: Colors.black,
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
                          "Price: ${vehiclesList[index].price.toString()}  |  Year: ${vehiclesList[index].year}",
                          style: TextStyle(
                            color: Color(0xff040415),
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
            ),
          );
        },
      ),
    );
  }

  Future<List<FavoriteVehicle>> _getAllFavorites() async {
    final vehicleProvider =
        Provider.of<VehiclesProvider>(context, listen: false);
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    UserResponse response = await authProvider.getCurrentUser();
    List<FavoriteVehicle> favs =
        await vehicleProvider.getAllFavoriteVehicles(response.id!);
    return favs;
  }

  _buildaFavoriteOld(bool hasVideo, String name, String finalPrice) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset('assets/audi.png'),
              ),
              hasVideo
                  ? Padding(
                      padding: const EdgeInsets.only(top: 150, left: 15),
                      child: Image.asset("assets/video.png"),
                    )
                  : SizedBox(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: SizedBox(
              width: 174,
              child: Text(
                name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Opacity(
              opacity: 0.50,
              child: Text(
                finalPrice,
                style: TextStyle(
                  color: Color(0xff040415),
                  fontSize: 12,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildSearchSection() {
    return SearchSection();
  }
}
