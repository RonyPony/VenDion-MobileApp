import 'package:flutter/cupertino.dart';
import 'package:vendion/screens/car_details_screen.dart';
import 'package:vendion/screens/favorites_screen.dart';
import 'package:vendion/screens/filters_screen.dart';
import 'package:vendion/screens/home_screen.dart';
import 'package:vendion/screens/login_screen.dart';
import 'package:vendion/screens/notifications_screen.dart';
import 'package:vendion/screens/profile_screen.dart';
import 'package:vendion/screens/register_screen.dart';
import 'package:vendion/screens/sell_vehicle.dart';

final Map<String, WidgetBuilder> routes = {
  // LandingPage.routeName: (context) => const LandingPage(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  RegisterScreen.routeName: (context) => const RegisterScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  FiltersScreen.routeName: (context) =>  FiltersScreen(),
  NotificationsScreen.routeName: (context) => NotificationsScreen(),
  FavoriteScreen.routeName: (context) => FavoriteScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  SellScreen.routeName:(context) => SellScreen(),
  VehicleDetails.routeName:((context) => VehicleDetails())
};
