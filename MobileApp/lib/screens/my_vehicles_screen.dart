import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vendion/models/user_response.dart';
import 'package:vendion/models/vehicles.dart';
import 'package:vendion/providers/auth_provider.dart';
import 'package:vendion/providers/photo_provider.dart';
import 'package:vendion/providers/vehicles_provider.dart';
import 'package:vendion/screens/car_details_screen.dart';
import 'package:vendion/services/user_service.dart';

import '../models/photo.dart';
import '../widgets/bottom_menu.dart';
import '../widgets/drawer.dart';
import '../widgets/search_section.dart';
import 'notifications_screen.dart';

class MyVehiclesScreen extends StatefulWidget {
  static String routeName = "/myvehiclesScreen";

  MyVehiclesScreen({Key? key}) : super(key: key);

  @override
  _MyVehiclesScreenState createState() => _MyVehiclesScreenState();
}

class _MyVehiclesScreenState extends State<MyVehiclesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          FutureBuilder<Widget>(
            future: _buildMyVehicles(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LinearProgressIndicator(
                  color: Colors.grey,
                  backgroundColor: Colors.white,
                );
              }
              if (snapshot.hasError) {
                return Text("Error Loading Vehicles");
              }
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return snapshot.data!;
              }

              return Text("Not Vehicles Found");
            },
          ),
          BottomMenu(
            currentIndex: 2,
          ),
        ],
      ),
    );
  }
  
  Future<Widget> _buildMyVehicles() async {
    final provider = Provider.of<VehiclesProvider>(context,listen: false);
    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    final photoProvider = Provider.of<PhotoProvider>(context,listen: false);
    UserResponse user =await authProvider.getCurrentUser();
    List<Vehicle> userVehicles = await provider.getVehiclesByUser(user.id!);

    return ListView.builder(
      itemCount: userVehicles.length,
      itemBuilder: (context, index) {
        Future<Photo> carImage = photoProvider.getVehiclePicture(userVehicles[index].id!);
        return FutureBuilder<Photo>(
          future: carImage,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LinearProgressIndicator(backgroundColor: Colors.white,color: Colors.green,minHeight: 2,);
            }
            if (snapshot.hasError) {
              return Text("Error loading");
            }
            if (snapshot.connectionState ==ConnectionState.done && snapshot.hasData) {
             
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, VehicleDetails.routeName,arguments: userVehicles[index]);
                  },
                  child: ListTile(
                    // leading: Image.memory(base64Decode(snapshot.data!.image!)),
                    title: Text(userVehicles[index].name!),
                    subtitle: Text(userVehicles[index].description!),//.substring(0,20)+"..."),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.orange,),
                  ),
                ),
              );
            }

            return Text("Error cargando las imagenes");
          },
        );
      },
    );
  }
}