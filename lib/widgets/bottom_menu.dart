import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vendion/screens/favorites_screen.dart';
import 'package:vendion/screens/home_screen.dart';
import 'package:vendion/screens/profile_screen.dart';

class BottomMenu extends StatefulWidget {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  BottomMenu({Key? key, required this.currentIndex}) : super(key: key);
final int currentIndex;
  @override
  State<BottomMenu> createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  int _selectedIndex = 0;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedIndex = widget.currentIndex;
  }
  void _onItemTapped(int index) {
    setState(() {
      if (_selectedIndex!=index) {
        if (index == 0) {
          Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.routeName, (route) => false);
        }
        if (index == 1) {
          Navigator.pushNamedAndRemoveUntil(
              context, FavoriteScreen.routeName, (route) => false);
        }
        if (index == 2) {
          Navigator.pushNamedAndRemoveUntil(
          context, ProfileScreen.routeName, (route) => false);
        }
        _selectedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    if (Platform.isIOS) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 0, top: 0, left: 0, right: 0),
          child: Container(
            padding: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: Color(0xffff5b00),
                borderRadius: BorderRadius.circular(50)),
            child: BottomNavigationBar(
              elevation: 0,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              backgroundColor: Colors.transparent,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    size: 35,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.favorite_rounded,
                    size: 35,
                  ),
                  label: 'Favorite',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                    size: 35,
                  ),
                  label: 'Profile',
                ),
              ],
              currentIndex: _selectedIndex,
              unselectedItemColor: Color(0xffcccccc),
              selectedItemColor: Colors.white,
              onTap: _onItemTapped,
            ),
          ),
        ),
      );
      
    } else {
     return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
          child: Container(
            decoration: BoxDecoration(
                color: Color(0xffff5b00),
                borderRadius: BorderRadius.circular(50)),
            child: BottomNavigationBar(
              elevation: 0,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              backgroundColor: Colors.transparent,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    size: 35,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.favorite_rounded,
                    size: 35,
                  ),
                  label: 'Favorites',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                    size: 35,
                  ),
                  label: 'Profile',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedIconTheme: IconThemeData(
                
              ),
              unselectedItemColor: Colors.white.withOpacity(.3),
              selectedItemColor: Colors.white,
              onTap: _onItemTapped,
            ),
          ),
        ),
      );
    }
    return SizedBox();
    
  }
}
