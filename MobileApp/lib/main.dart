import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendion/contracts/vehicles_contract.dart';
import 'package:vendion/providers/auth_provider.dart';
import 'package:vendion/providers/vehicles_provider.dart';
import 'package:vendion/routes.dart';
import 'package:vendion/screens/login_screen.dart';
import 'package:vendion/services/authentication_service.dart';
import 'package:vendion/services/user_service.dart';
import 'package:vendion/services/vehicle_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              AuthenticationProvider(AuthenticationService(), UserService()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              VehiclesProvider(VehicleService()),
        ),
      ],
      child: MaterialApp(
        title: 'VenDionApp',
        routes: routes,

        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen(),

        // home: const MyHomePage(title: 'Loading'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title:Text("VenDion"),
      ),
      
    );
  }
}
