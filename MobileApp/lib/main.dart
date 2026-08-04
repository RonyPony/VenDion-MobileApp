import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vendion/config/app_theme.dart';
import 'package:vendion/l10n/app_localizations.dart';
import 'package:vendion/providers/auth_provider.dart';
import 'package:vendion/providers/messages_provider.dart';
import 'package:vendion/providers/photo_provider.dart';
import 'package:vendion/providers/settings_provider.dart';
import 'package:vendion/providers/vehicles_provider.dart';
import 'package:vendion/routes.dart';
import 'package:vendion/screens/login_screen.dart';
import 'package:vendion/services/authentication_service.dart';
import 'package:vendion/services/credential_cache_service.dart';
import 'package:vendion/services/mock_messages_service.dart';
import 'package:vendion/services/photo_service.dart';
import 'package:vendion/services/settings_service.dart';
import 'package:vendion/services/user_service.dart';
import 'package:vendion/services/vehicle_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthenticationProvider(
            AuthenticationService(),
            UserService(),
            CredentialCacheService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              SettingsProvider(SettingsService())..loadSettings(),
        ),
        ChangeNotifierProvider(
          create: (context) => VehiclesProvider(VehicleService()),
        ),
        ChangeNotifierProvider(
          create: (context) => MessagesProvider(MockMessagesService()),
        ),
        ChangeNotifierProvider(
          create: (context) => PhotoProvider(PhotoService()),
        )
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return MaterialApp(
            title: 'VenDionApp',
            routes: routes,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: settings.themeMode,
            locale: Locale(settings.languageCode),
            supportedLocales: AppLocalizations.supportedLanguages
                .map((languageCode) => Locale(languageCode)),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const LoginScreen(),
          );
        },
      ),
    );
  }
}
