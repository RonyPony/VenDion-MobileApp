import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vendion/screens/filters_screen.dart';
import 'package:vendion/screens/notifications_screen.dart';
import 'package:vendion/widgets/bottom_menu.dart';
import 'package:vendion/widgets/carrousel.dart';
import 'package:vendion/widgets/drawer.dart';

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
                onTap: (){
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
                  _buildRecommendedSection(
                      MediaQuery.of(context).size.width * .30),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .15,
                  )
                ],
              ),
            ),
            BottomMenu(currentIndex: 0,),
          ],
        ));
  }

  _buildRecommendedSection(double ancho) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
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
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildaRecommended(true, true, "Audi Q7 Sport", "US. 23,000"),
                  _buildaRecommended(
                      false, true, "Audi Q7 Sport", "US. 23,000"),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildaRecommended(true, true, "Audi Q7 Sport", "US. 23,000"),
                  _buildaRecommended(
                      false, true, "Audi Q7 Sport", "US. 23,000"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildSearchSection() {
    return Row(
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
    );
  }

  _buildCarrouser() {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
      child: Carrousel(),
    );
  }

  _buildaRecommended(
      bool liked, bool hasVideo, String name, String finalPrice) {
    return Column(
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
            liked
                ? Padding(
                    padding: const EdgeInsets.only(top: 10, left: 150),
                    child: SvgPicture.asset("assets/liked.svg"),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 10, left: 150),
                    child: SvgPicture.asset(
                      "assets/notliked.svg",
                      width: 26,
                    ),
                  )
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
    );
  }
}
