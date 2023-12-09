import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tsd_project/screen/login.dart';

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
      //Center the whole column with the layout builder
      body: Center(
        //Create a layout builder to adjust the size
        child: LayoutBuilder(builder: (context, constraints) {
          // Calculate the max size based on the smaller dimension (width or height)
          double maxSize = constraints.maxWidth < constraints.maxHeight
              ? constraints.maxWidth
              : constraints.maxHeight;

          // Set a percentage of the max size for your Image
          double imageSize = maxSize * 0.6;

          return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('DEPRESSION DETECTOR',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    //Set a percentage of imagesize for the fontsize
                    fontSize: imageSize * 0.15,
                    color: const Color.fromARGB(255, 48, 17, 134))),
            const SizedBox(
              height: 15.0,
            ),
            Image.asset(
              'assets/images/splash_image.jpg',
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 15.0,
            ),
            const CircularProgressIndicator(),
          ]);
        }),
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
