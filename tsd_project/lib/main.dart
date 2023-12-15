import 'package:flutter/material.dart';
import 'screen/splash_screen.dart';
import 'screen/welcome_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(home: Splash());
    return MaterialApp(home: Welcome());
  }
}
