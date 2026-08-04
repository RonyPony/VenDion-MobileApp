import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vendion/config/app_constants.dart';
import 'package:vendion/screens/my_vehicles_screen.dart';
import 'package:vendion/screens/sell_vehicle.dart';
import 'package:vendion/screens/settings_screen.dart';

import '../widgets/bottom_menu.dart';
import '../widgets/drawer.dart';
import '../widgets/notification_button.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profileScreen";

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: GeneralDrawer(),
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * .1,
        actions: const [NotificationButton()],
        title: const Text(
          "VenDion",
          textAlign: TextAlign.center,
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 110),
            child: Column(
              children: [
                _buildImage(),
                _buildOption(
                  context,
                  iconName: "car",
                  name: "Vender un coche",
                  routeName: SellScreen.routeName,
                ),
                _buildOption(
                  context,
                  iconName: "setting",
                  name: "Configuracion",
                  routeName: SettingsScreen.routeName,
                ),
                _buildOption(
                  context,
                  icon: Icons.directions_car_filled_outlined,
                  name: "Mis publicaciones",
                  routeName: MyVehiclesScreen.routeName,
                ),
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
        children: const [
          CircleAvatar(
            radius: 68,
            backgroundColor: Color(0xa0ff5b00),
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

  Widget _buildOption(
    BuildContext context, {
    String? iconName,
    IconData? icon,
    required String name,
    required String routeName,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 390),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.md),
                color: theme.brightness == Brightness.dark
                    ? const Color(0xff1d1d24)
                    : AppColors.lightSurface,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 44,
                    height: 50,
                    child: iconName != null
                        ? SvgPicture.asset("assets/$iconName.svg")
                        : Icon(icon, color: AppColors.primary),
                  ),
                  Expanded(
                    child: Text(
                      name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.mutedText,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 37,
                    height: 34,
                    child: SvgPicture.asset("assets/next.svg"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
