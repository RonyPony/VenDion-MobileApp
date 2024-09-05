import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vendion/models/user_response.dart';
import 'package:vendion/models/vehicle_photo.dart';
import 'package:vendion/providers/auth_provider.dart';
import 'package:vendion/providers/vehicles_provider.dart';
import 'package:vendion/screens/car_details_screen.dart';
import 'package:vendion/screens/filters_screen.dart';
import 'package:vendion/screens/notifications_screen.dart';
import 'package:vendion/widgets/bottom_menu.dart';
import 'package:vendion/widgets/carrousel.dart';
import 'package:vendion/widgets/drawer.dart';

import '../models/vehicles.dart';
import '../widgets/main_button_widget.dart';
import '../widgets/textBox_widget.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/homeScreen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //0 is all
  //1 is new
  //2 is used
  int _carConditions = 0;
  bool isSearching = false;

  bool isSearchingLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: GeneralDrawer(),
        // bottomNavigationBar: BottomMenu(),
        backgroundColor: Colors.white,
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
                children: [
                  _buildSearchSection(),
                  _buildCarrouser(),
                  FutureBuilder<Widget>(
                    future: _buildRecommendedSection(
                        MediaQuery.of(context).size.width * .30),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("Error ");
                      }

                      if (!snapshot.hasData) {
                        return Text("No data found");
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      if (snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.done) {
                        return snapshot.data!;
                      }
                      return Text("no data");
                    },
                  ),
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

  Future<Widget> _buildRecommendedSection(double ancho) async {
    final vehicleProvider =
        Provider.of<VehiclesProvider>(context, listen: false);
    final authProv =
        Provider.of<AuthenticationProvider>(context, listen: false);
    UserResponse usr = await authProv.getCurrentUser();
    Future<List<Vehicle>> _allVehicles =
        vehicleProvider.getAllAvailableVehicles(usr.id!);

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
                "Recommended",
                style: TextStyle(
                  color: Color(0xff040415),
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
                  "See all",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Color(0xff040415),
                    fontSize: 16,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
          FutureBuilder<List<Vehicle>>(
            future: _allVehicles,
            builder: (context, vehicleListSnapshot) {
              if (vehicleListSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return CircularProgressIndicator(color: Color(0xffff5b00));
              }
              if (vehicleListSnapshot.hasError) {
                return Text("Error");
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
                    final authProvider = Provider.of<AuthenticationProvider>(
                        context,
                        listen: false);
                    Future<UserResponse> currentUser =
                        authProvider.getCurrentUser();

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

              return Text("No info");
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
                  color: const Color(0xffedeeef),
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
                          if (value == "") {
                            isSearching = false;
                          } else {
                            isSearching = true;
                          }
                          setState(() {});
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(20)),
                            hintText: "Search for Honda Pilot 7-Passenger"),
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
          loadingText: "Searching...",
          onTap: () {
            setState(() {
              isSearchingLoading = true;
            });
          },
          text: "Search",
        ),
      ),
    );
  }

  _buildCarrouser() {
    final vehicleProvider =
        Provider.of<VehiclesProvider>(context, listen: false);
    Future<List<Vehicle>> offers = vehicleProvider.getAllOfferVehicle();
    return FutureBuilder<List<Vehicle>>(
      future: offers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LinearProgressIndicator(
            color: Color(0xffff5b00),
            backgroundColor: Colors.white,
          );
        }
        if (snapshot.hasError) {
          return Text("Error");
        }
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          return Padding(
            padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
            child: Carrousel(snapshot.data!),
          );
        }

        return Text("No content available");
      },
    );
  }

  _buildaRecommended(Vehicle vehicle, VehiclesProvider provider) {
    bool hasVideo = true;
    bool liked = vehicle.isFavorite!;
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
            FutureBuilder<VehiclePhoto>(
              future: _carPhoto,
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
                if (snapshot.hasError || snapshot.data!.image == null) {
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
                              image: Image.memory(
                                      base64Decode(snapshot.data!.image!))
                                  .image,
                            ),
                          ),
                        ),
                      ),
                      hasVideo
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(top: 160, left: 15),
                              child: Image.asset("assets/video.png"),
                            )
                          : SizedBox(),
                      liked
                          ? Padding(
                              padding: EdgeInsets.only(
                                  top: 10,
                                  left:
                                      MediaQuery.of(context).size.width * .75),
                              child: GestureDetector(
                                  onTap: () {
                                    print("Liked ${vehicle.name}");
                                  },
                                  child: SvgPicture.asset("assets/liked.svg")),
                            )
                          : Padding(
                              padding: EdgeInsets.only(
                                  top: 10,
                                  left:
                                      MediaQuery.of(context).size.width * .75),
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
                  vehicle.name!.capitalize(),
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
                  "Price: ${vehicle.price.toString()}  |  Year: ${vehicle.year}",
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
    );
  }
}
