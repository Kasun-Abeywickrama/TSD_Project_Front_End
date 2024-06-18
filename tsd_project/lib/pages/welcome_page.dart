import 'dart:async';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:tsd_project/important_tools/user_authentication.dart';
import 'package:tsd_project/pages/main_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    initialProcess(context);
  }

  Future<void> initialProcess(BuildContext context) async {
    if (context.mounted) {
      await Future.delayed(const Duration(seconds: 2));
      if (context.mounted) {
        if (await checkLoginStatus(context)) {
          if (context.mounted) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MainPage()));
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Container(
      width: double.infinity, // Set the width of the container
      height: double.infinity, // Set the height of the container
      decoration: BoxDecoration(
        // Adding decoration to the container to display the image
        image: const DecorationImage(
          image: AssetImage(
              'assets/images/background.png'), // Replace with your image path
          fit: BoxFit
              .cover, // Adjust the way the image fits inside the container
        ),
        borderRadius:
            BorderRadius.circular(12.0), // Optional: Adding border radius
      ),
      child: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.68,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'Mind Care',
                style: TextStyle(
                  fontSize: screenWidth * 0.1,
                  fontFamily: 'archivo_black.ttf',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            height: screenHeight * 0.07,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'Only Accessible Through NSBM Wifi Network',
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  fontFamily: 'archivo_black.ttf',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            height: screenHeight * 0.05,
          ),
          SizedBox(
              height: screenHeight * 0.075,
              width: screenHeight * 0.075,
              child: const LoadingIndicator(
                indicatorType: Indicator.ballPulse,
                colors: [Color.fromRGBO(0, 57, 255, 0.8)],
                strokeWidth: 30,
              ))
        ],
      ),
    ));
  }
}
