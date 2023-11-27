import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tsd_project/login.dart';

//Steps that are used to create the splash screen of the mobile application
//Create an stateless widget
//Override the widget build and create your splash screen content
//Convert this stateless widget into a statefull widget
//Then, create an initState() - the purpose of this is to display the splash screen for few seconds and redirect to home page
//Edit the main.dart to display the splash screen in the startup

class Splash extends StatefulWidget {
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('WE ARE HERE TO HELP YOU',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Color.fromARGB(255, 48, 17, 134))),
          Image.asset(
            'assets/images/splash_image.jpg',
            fit: BoxFit.fill,
          ),
          const Text(
            'DEPRESSION DETECTOR',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Color.fromARGB(255, 48, 17, 134)),
          ),
        ]),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => login_user()));
    });
  }
}
