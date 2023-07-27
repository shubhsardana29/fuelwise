import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fuelwise/widgets/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FuelWise',
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF63FFE4),
      ),
      home: SplashScreen(), 
    );
  }
}
