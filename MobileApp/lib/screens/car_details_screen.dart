import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:provider/provider.dart';
import 'package:vendion/models/user_response.dart';
import 'package:vendion/models/vehicle_photo.dart';
import 'package:vendion/models/vehicles.dart';
import 'package:vendion/providers/auth_provider.dart';
import 'package:vendion/providers/vehicles_provider.dart';

import '../widgets/main_button_widget.dart';
import 'home_screen.dart';

class VehicleDetails extends StatefulWidget {
  static String routeName = "/vehicleDetails";
  VehicleDetails({Key? key}) : super(key: key);

  @override
  State<VehicleDetails> createState() => _VehicleDetailsState();
}

class _VehicleDetailsState extends State<VehicleDetails> {
  Vehicle _carInfo = Vehicle();
  String currentPhotoFromGallery = "";
  bool isFavorite = false;
  
  bool addingToFavorite = false;
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments! as Vehicle;

    _carInfo = args;
    final provider = Provider.of<VehiclesProvider>(context, listen: false);

    Future<VehiclePhoto> _carPhoto = provider.getVechiclePhoto(_carInfo.id!);
    Future<List<VehiclePhoto>> _carGallery =
        provider.getVechicleGallery(_carInfo.id!);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [Icon(Icons.share_rounded)],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildGallery(_carPhoto, _carGallery),
            _buildTitle(),
            _buildDescription(),
            _buildFeatures(),
            _buildOptions(),
            FutureBuilder<Widget>(
              future: _buildAdd2FavBtn(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(
                    color: Color(0xffff5b00),
                  );
                }
                if (snapshot.hasError) {
                  return Text("Error occur");
                }

                if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                  return snapshot.data!;
                }
                return Text("no data");
              },
            ),
            _buildBuyNowBtn(),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGallery(
      Future<VehiclePhoto> mainPhoto, Future<List<VehiclePhoto>> gallery) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            FutureBuilder<VehiclePhoto>(
              future: mainPhoto,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox();
                  // Container(
                  //   padding: EdgeInsets.only(
                  //       left: MediaQuery.of(context).size.width * .3, top: 20),
                  //   child: CircularProgressIndicator(
                  //     color: Color(0xffff5b00),
                  //     semanticsLabel: "Loading",
                  //   ),
                  // );
                }
                if (snapshot.hasError) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("Error Getting Vehicle photo")],
                  );
                }

                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(9),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: currentPhotoFromGallery == ""
                              ? Container(
                                  width:
                                      MediaQuery.of(context).size.width * .95,
                                  height:
                                      MediaQuery.of(context).size.width * .80,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: Image.memory(base64Decode(
                                                snapshot.data!.image!))
                                            .image),
                                  ),
                                )
                              : Container(
                                  width:
                                      MediaQuery.of(context).size.width * .95,
                                  height: 300,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: Image.memory(base64Decode(
                                                currentPhotoFromGallery))
                                            .image),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  );
                }
                return Image.asset("assets/carDetailsPlaceholder.png");
              },
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .35),
              child: Row(
                children: [
                  FutureBuilder<List<VehiclePhoto>>(
                    future: gallery,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Row(
                          children: [
                            Container(
                              height: 3,
                              width: MediaQuery.of(context).size.width,
                              child: LinearProgressIndicator(
                                backgroundColor: Colors.white,
                                color: Color(0xffff5b00),
                              ),
                            ),
                          ],
                        );
                      }
                      if (snapshot.hasError) {
                        return Text("Err");
                      }
                      if (snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.done) {
                        return Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return snapshot.data!.length >= 2
                                  ? Container(
                                      padding: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            currentPhotoFromGallery =
                                                snapshot.data![index].image!;
                                          });
                                        },
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              10,
                                          child: Image.memory(base64Decode(
                                              snapshot.data![index].image!)),
                                        ),
                                      ),
                                    )
                                  : SizedBox();
                            },
                          ),
                        );
                      }
                      return Text("No Data");
                    },
                  ),
                  // Container(
                  //   decoration: BoxDecoration(),
                  //   child: Container(
                  //     height: MediaQuery.of(context).size.height / 10,
                  //     child: Image.asset("assets/carDetailsPlaceholder.png"),
                  //   ),
                  // ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  // Container(
                  //   decoration: BoxDecoration(),
                  //   child: Container(
                  //     height: MediaQuery.of(context).size.height / 10,
                  //     child: Image.asset("assets/carDetailsPlaceholder.png"),
                  //   ),
                  // ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  // Container(
                  //   decoration: BoxDecoration(),
                  //   child: Container(
                  //     height: MediaQuery.of(context).size.height / 10,
                  //     child: Image.asset("assets/carDetailsPlaceholder.png"),
                  //   ),
                  // )
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  _buildTitle() {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Text(
                _carInfo.name!.capitalize(),
                style: TextStyle(
                  color: Color(0xff040415),
                  fontSize: 22,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .4 -
                  _carInfo.name!.length * 5,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                "4.5/5",
                style: TextStyle(
                  color: Color(0xffff5b00),
                  fontSize: 18.64,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(width: 6.55),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Icon(
                Icons.star_rounded,
                color: Color(0xffff5b00),
              ),
            )
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Opacity(
                opacity: 0.50,
                child: Text(
                  "US ${_carInfo.price.toString()}",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Color(0xff040415),
                    fontSize: 14,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  _buildDescription() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20),
      child: Opacity(
        opacity: 0.40,
        child: Column(
          children: [
            Text(
              _carInfo.description!,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            _carInfo.description!.length >= 100
                ? Row(
                    children: [
                      Text(
                        "Read more...",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xffff5b00),
                        ),
                      ),
                    ],
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }

  _buildFeatures() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20),
      child: Column(
        children: [
          Row(
            children: [
              _carInfo.features!.length > 2
                  ? Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 25,
                      color: Color(0xffff5b00),
                    )
                  : SizedBox(),
              // SizedBox(width: MediaQuery.of(context).size.width*.8,),
              Container(
                // color: Colors.red,
                height: 70,
                width: MediaQuery.of(context).size.width * .8,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _carInfo.features!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return aFeature(_carInfo.features![index]);
                  },
                ),
              ),
              _carInfo.features!.length > 2
                  ? Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 25,
                      color: Color(0xffff5b00),
                    )
                  : SizedBox()
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Opacity(
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
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  aFeature(String s) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Chip(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(5),
                bottomRight: Radius.circular(5),
                bottomLeft: Radius.circular(5),
                topLeft: Radius.circular(5))),
        backgroundColor: Color(0xffff5b00),
        label: Container(
          // width: 100,
          child: Row(
            children: [
              Icon(
                Icons.check_box_rounded,
                color: Colors.white,
              ),
              Text(
                s,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildOptions() {
    return Opacity(
      opacity: .5,
      child: Padding(
        padding: const EdgeInsets.only(left: 50, top: 15),
        child: Column(
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.handshake_rounded,
                    ),
                    Text("Contact Dealer")
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .14,
                ),
                Row(
                  children: [Icon(Icons.car_rental), Text("Car Details")],
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on),
                    Text("Santo Domingo Este")
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .05,
                ),
                Row(
                  children: [Icon(Icons.attach_money), Text("Financiamiento")],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _buildBuyNowBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.routeName, (route) => false);
        },
        child: CustomBtn(
          mainBtn: true,
          onTap: () {},
          enable: true,
          text: "Buy Now",
        ),
      ),
    );
  }

  Future<Widget>_buildAdd2FavBtn() async {
    final prov = Provider.of<VehiclesProvider>(context, listen: false);
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    UserResponse usr = await authProvider.getCurrentUser();
    bool isFavorite = await prov.isFavorite(_carInfo.id!,usr.id!);


    return !isFavorite?Padding(
      padding: const EdgeInsets.only(top: 20),
      child: GestureDetector(
        onTap: () async {
         
          setState(() {
             addingToFavorite=true;
          });
          final authProv =
              Provider.of<AuthenticationProvider>(context, listen: false);
          UserResponse usr = await authProv.getCurrentUser();
          // prov.addToFavorite(_carInfo.id!, usr.id!);
          Future.delayed(Duration(seconds: 2),(){
           setState(() {}); 
          });
          prov.addToFavorite(_carInfo.id!, usr.id!);
          
        },
        child: Container(
          width: MediaQuery.of(context).size.width * .8,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.withOpacity(.2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(!addingToFavorite?
                "Add To Favorites":"Updating...",
                style: TextStyle(
                  color: !addingToFavorite?Color(0xffff5b00):Color(0xffff5b00).withOpacity(.5),
                  fontSize: 18,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    )
    :
    Padding(
            padding: const EdgeInsets.only(top: 20),
            child: GestureDetector(
              onTap: () async {
                setState(() {
                  addingToFavorite = false;
                });
                final authProv =
                    Provider.of<AuthenticationProvider>(context, listen: false);
                UserResponse usr = await authProv.getCurrentUser();
                // prov.addToFavorite(_carInfo.id!, usr.id!);
                Future.delayed(Duration(seconds: 1), () {
                  setState(() {});
                });
                bool x = await prov.removeFromFavorite(_carInfo.id!, usr.id!);
                print(x);
              },
              child: Container(
                width: MediaQuery.of(context).size.width * .8,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xffff5b00),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Remove from Favorites",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
