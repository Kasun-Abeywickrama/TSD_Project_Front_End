import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tsd_project/important_tools/user_authentication.dart';
import 'package:tsd_project/screen/main_screen.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
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
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => MainScreen()));
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
            height: screenHeight * 0.75,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'Welcome',
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
            height: screenHeight * 0.05,
          ),
          SizedBox(
              height: screenHeight * 0.045,
              width: screenHeight * 0.045,
              child: const CircularProgressIndicator(
                color: Color.fromRGBO(0, 57, 255, 0.8),
              ))
        ],
      ),
    ));
  }
}
