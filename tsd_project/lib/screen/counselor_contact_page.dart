import 'package:flutter/material.dart';

class CounselorContact extends StatelessWidget {
  const CounselorContact({super.key});

  @override
  Widget build(BuildContext context) {
    String hexColorCode = '#055FA0'; // Replace with your hexadecimal color code
    return Scaffold(
      body: Container (
        width: double.infinity,
        height: double.infinity,
        color: Colors.black12,
        child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 130,
              color: Color(int.parse(hexColorCode.replaceFirst('#', '0xFF'))),
              padding: EdgeInsets.only(
                left: 10,
                top: 40,
              ),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Info',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    'Dr. Joseph Zuckerman',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
            Center(
              child: Image.asset(
                'assets/images/doctor.png', // Replace with your image path
                height: 130,
                width: 120,
              ),
            ),//

            SizedBox(height: 20),// Adding space between text and image
            Center(
              child: Container(
                height: 350,
                width: 300,
                padding: EdgeInsets.only(
                  top: 30.0,
                  left: 20.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(
                    'Location',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20,
                  ),
                  ),
                    Text(
                      '20, Pitipana Road, Homagama',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(height: 25),// Adding space between text and image
                  Text(
                    'Phone',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '0777123456',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(height: 25),
                  Text(
                    'Email',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'josephzuckerman@gmail.com',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(height: 25),
                  Text(
                    'Website',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'joseph.xyz',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(height: 25),
                  ]
                ),
              ),
            ),

          ]
        ),
      ),
    );
  }
}
