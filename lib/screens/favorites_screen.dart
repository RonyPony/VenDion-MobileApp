import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vendion/widgets/drawer.dart';

import '../widgets/bottom_menu.dart';
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
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildaFavorite(true, "name", "finalPrice"),
                          _buildaFavorite(true, "name", "finalPrice"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildaFavorite(true, "name", "finalPrice"),
                          _buildaFavorite(true, "name", "finalPrice"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildaFavorite(true, "name", "finalPrice"),
                          _buildaFavorite(true, "name", "finalPrice"),
                        ],
                      ),
                      SizedBox(height: 100,)
                    ],
                  )
                ],
              ),
            ),
            BottomMenu(
              currentIndex: 1,
            ),
          ],
        ));
  }

  _buildaFavorite(bool hasVideo, String name, String finalPrice) {
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
}
