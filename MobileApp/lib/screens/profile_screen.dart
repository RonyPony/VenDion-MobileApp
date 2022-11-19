import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vendion/screens/home_screen.dart';
import 'package:vendion/screens/my_vehicles_screen.dart';
import 'package:vendion/screens/sell_vehicle.dart';

import '../widgets/bottom_menu.dart';
import '../widgets/drawer.dart';
import 'notifications_screen.dart';

class ProfileScreen extends StatefulWidget {
  static String routeName = "/profileScreen";

  @override
  State<ProfileScreen> createState() => _stateProfileScreen();
}

class _stateProfileScreen extends State<ProfileScreen> {

  
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
          SingleChildScrollView(
            child: Column(
              children: [
                _buildImage(),
                _buildSell(),
                _buildSetting(),
                _buildMyVehicles()
              ],
            ),
          ),
          BottomMenu(
            currentIndex: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 136,
            height: 135,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xa0ff5b00),
            ),
            child: Icon(
              Icons.person_pin,
              color: Colors.white,
              size: 115,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSell() {
    Size screen = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, SellScreen.routeName);
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding:
                  EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffedeeef),
              ),
              child: Container(
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SvgPicture.asset("assets/car.svg"),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: screen.width * .1, right: screen.width * .1),
                      child: Text(
                        "Vender un coche",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff8c9199),
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      width: 37,
                      height: 34,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SvgPicture.asset("assets/next.svg"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildSetting() {
    // return _buildAnOption("setting", "Configuracion",HomeScreen.routeName);
    Size screen = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, HomeScreen.routeName);
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding:
                  EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffedeeef),
              ),
              child: Container(
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SvgPicture.asset("assets/setting.svg"),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: screen.width * .1, right: screen.width * .1),
                      child: Text(
                        "Configuracion",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff8c9199),
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      width: 37,
                      height: 34,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SvgPicture.asset("assets/next.svg"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyVehicles() {
    // return _buildAnOption("myVehicles", "Mis publicaciones", MyVehiclesScreen.routeName);
    Size screen = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, MyVehiclesScreen.routeName);
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding:
                  EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffedeeef),
              ),
              child: Container(
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      // child: SvgPicture.asset("assets/$iconName.svg"),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: screen.width * .1, right: screen.width * .1),
                      child: Text(
                        "Mis publicaciones",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff8c9199),
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      width: 37,
                      height: 34,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SvgPicture.asset("assets/next.svg"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  _buildAnOption(String iconName,String name,String routeName){
    Size screen = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, routeName);
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(left: 25,right: 25,top: 10,bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffedeeef),
              ),
              child: Container(
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SvgPicture.asset("assets/$iconName.svg"),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(left:screen.width*.1,right: screen.width*.1),
                      child: Text(
                        name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff8c9199),
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      width: 37,
                      height: 34,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SvgPicture.asset("assets/next.svg"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  
}
