import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vendion/screens/home_screen.dart';

class GeneralDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white.withOpacity(.8),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration:  BoxDecoration(
              color: Colors.transparent,
            ),
            child: Image.asset("assets/logo.png"),//SvgPicture.asset("assets/logo.svg"),
          ),
          ListTile(
            
            title: const Text('Home',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
            },
          ),
          ListTile(
            title: const Text('Favorites',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text('Profile',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text('Recommended',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text('Filters',style: TextStyle(color: Colors.black),),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text('Notifications',style: TextStyle(color: Colors.black),),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text('Settings',style: TextStyle(color: Colors.black,
              ),),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
SizedBox(height: MediaQuery.of(context).size.height*.25,),
          ListTile(
            title: const Text('Logout',style: TextStyle(color: Colors.black),),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
        ],
      ),
    );
  }
}
