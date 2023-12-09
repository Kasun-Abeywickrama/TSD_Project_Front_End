import 'package:flutter/material.dart';
import 'package:tsd_project/quiz_receiver.dart';
import 'package:tsd_project/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Splash());
  }
}
