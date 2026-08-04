import 'package:flutter/material.dart';
import 'package:vendion/config/app_constants.dart';

class AppTheme {
  static ThemeData light() {
    return _base(Brightness.light).copyWith(
      scaffoldBackgroundColor: Colors.white,
      cardColor: Colors.white,
      drawerTheme: const DrawerThemeData(backgroundColor: Colors.white),
    );
  }

  static ThemeData dark() {
    return _base(Brightness.dark).copyWith(
      scaffoldBackgroundColor: const Color(0xff101014),
      cardColor: const Color(0xff18181d),
      drawerTheme: const DrawerThemeData(backgroundColor: Color(0xff18181d)),
    );
  }

  static ThemeData _base(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: false,
      brightness: brightness,
      colorScheme: colorScheme,
      primaryColor: AppColors.primary,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: brightness == Brightness.dark
            ? const Color(0xff101014)
            : Colors.white,
        foregroundColor:
            brightness == Brightness.dark ? Colors.white : Colors.black,
        titleTextStyle: const TextStyle(
          color: AppColors.primary,
          fontSize: 24,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.primary,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(.35),
      ),
    );
  }
}
