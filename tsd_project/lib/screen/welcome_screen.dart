import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          width: double.infinity, // Set the width of the container
          height: double.infinity, // Set the height of the container
          decoration: BoxDecoration(
            // Adding decoration to the container to display the image
            image: const DecorationImage(
              image: AssetImage('assets/images/background.png'), // Replace with your image path
              fit: BoxFit.cover, // Adjust the way the image fits inside the container
            ),
            borderRadius: BorderRadius.circular(12.0), // Optional: Adding border radius
          ),
          child: const Stack(
            children: [
              Positioned(
                top: 450,
                left: 90,
                child:Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 55,
                    fontFamily:'archivo_black.ttf',
                    fontWeight:FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

        )
    );
  }
}