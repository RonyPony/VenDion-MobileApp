import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vendion/screens/favorites_screen.dart';
import 'package:vendion/screens/filters_screen.dart';
import 'package:vendion/screens/home_screen.dart';
import 'package:vendion/screens/login_screen.dart';
import 'package:vendion/screens/notifications_screen.dart';
import 'package:vendion/screens/profile_screen.dart';

class GeneralDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white.withOpacity(.8),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: Image.asset(
                "assets/logo.png"), //SvgPicture.asset("assets/logo.svg"),
          ),
          ListTile(
            title: const Text(
              'Home',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, HomeScreen.routeName, (route) => false);
            },
          ),
          ListTile(
            title: const Text(
              'Favorites',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, FavoriteScreen.routeName, (route) => false);
            },
          ),
          ListTile(
            title: const Text(
              'Profile',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.pushNamed(context, ProfileScreen.routeName);
            },
          ),
          ListTile(
            title: const Text(
              'Recommended',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text(
              'Filters',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.pushNamed(context, FiltersScreen.routeName);
            },
          ),
          ListTile(
            title: const Text(
              'Notifications',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.pushNamed(context, NotificationsScreen.routeName);
            },
          ),
          ListTile(
            title: const Text(
              'Settings',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onTap: () {
              // Navigator.pushNamed(context, )
            },
          ),
          SizedBox(
            height: 40,
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.circular(50)
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 8,
                  ),
                  child: Text(
                    'Logout',
                    style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 15),
                  ),
                )
              ],
            ),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginScreen.routeName, (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
