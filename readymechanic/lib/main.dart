import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:readymechanic/firebase_options.dart';
import 'package:readymechanic/splash_screen.dart';
import 'package:readymechanic/login.dart';
import 'package:readymechanic/mechanic/mechanic_registration.dart';
import 'package:readymechanic/customer/customer_registration.dart';
import 'package:readymechanic/customer/customer_home.dart';

import 'package:readymechanic/mechanic/mechanic_home.dart';
import 'package:readymechanic/customer/customer_booking.dart';
import 'package:readymechanic/customer/customer_booking_details.dart';
import 'package:readymechanic/customer/customer_vehicles.dart';
import 'package:readymechanic/customer/customer_add_vehicles.dart';
import 'package:readymechanic/customer/customer_profile.dart';
import 'package:readymechanic/customer/customer_book_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReadyMechanic',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/mechanic_registration': (context) =>
            const MechanicRegistrationScreen(),
        '/customer_registration': (context) =>
            const CustomerRegistrationScreen(),
        '/customer_dashboard': (context) => const CustomerHomeScreen(),
        '/mechanic_dashboard': (context) => const MechanicHomeScreen(),
        '/customer_booking': (context) => const CustomerBookingsListScreen(),
        '/customer_booking_details': (context) =>
            const CustomerBookingDetailsScreen(),
        '/customer_vehicles': (context) => const CustomerVehiclesScreen(),
        '/customer_add_vehicles': (context) =>
            const CustomerAddVehiclesScreen(),
        '/customer_profile': (context) => const CustomerProfileScreen(),
        '/customer_book_service': (context) =>
            const CustomerBookServiceScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
