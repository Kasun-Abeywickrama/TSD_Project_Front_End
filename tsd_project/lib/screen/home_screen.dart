import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void onImageClick() {
    // Add your desired action here
    print('Image clicked!');
    // You can navigate to another screen, show a dialog, etc.
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
          child: GNav(
            gap: 8,
            color: Colors.grey[800],
            activeColor: Colors.purple,
            tabBackgroundColor: Colors.purple.shade100,
            padding: EdgeInsets.all(10),
            onTabChange: (index){
              print(index);
            },
            tabs: [
              GButton(
                  icon: Icons.home,
                  text: 'Home',
              ),
              GButton(
                  icon: Icons.favorite_border,
                  text: 'Likes',
              ),
              GButton(
                  icon: Icons.search,
                  text: 'Search',
              ),
              GButton(
                  icon: Icons.settings,
                  text: 'Settings',
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text(''),
          leading: Container(
            padding: EdgeInsets.only(left: 5.0),
            width: double.infinity,
            child: GestureDetector(
              onTap: onImageClick,
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/profile_img.png'), // Provide the path to your image asset
              ),
            ),
          ),
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: const Icon(
                      Icons.notifications_outlined,
                      size: 40.0,
                      color: Color(0xFF573926),
                  ),
                  onPressed: () {
                    print('Notification icon tapped!');
                  },
                ),
                const Positioned(
                  right: 5.0,
                  top: 5.0,
                  child: CircleAvatar(
                    backgroundColor: Colors.orange,
                    radius: 11.0,
                    child: Text(
                      '8',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: ListView(
          children: [
            Container(
              width: double.infinity,
              height: 80.0,
              // color: Colors.blueAccent,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.lato(fontSize: 35.0, color: Colors.black),
                        children: <TextSpan>[
                          const TextSpan(
                            text: 'Good morning, ',
                          ),
                          TextSpan(
                            text: 'Sara',
                            style: GoogleFonts.pacifico(fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(
                            text: '!',
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              // color: Colors.grey,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 10.0, right: 25.0, left: 25.0),
                    // color: Colors.teal,
                    child: Text(
                      "How are you feeling today ?",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                  Container(
                    height: 120.0,
                    margin: EdgeInsets.only(left: 25.0, top: 15.0),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Container(
                          width: 80.0,
                          margin: EdgeInsets.only(right: 22.0),
                          child: Image.asset(
                            'assets/images/Happy.png', // Path to your image in the assets folder
                            fit: BoxFit.cover, // Adjust the fit as needed (cover, contain, etc.)
                          ),
                        ),
                        Container(
                          width: 80.0,
                          margin: EdgeInsets.only(right: 22.0),
                          child: Image.asset(
                            'assets/images/Calm.png', // Path to your image in the assets folder
                            fit: BoxFit.cover, // Adjust the fit as needed (cover, contain, etc.)
                          ),
                        ),
                        Container(
                          width: 80.0,
                          margin: EdgeInsets.only(right: 22.0),
                          child: Image.asset(
                            'assets/images/Relax.png', // Path to your image in the assets folder
                            fit: BoxFit.cover, // Adjust the fit as needed (cover, contain, etc.)
                          ),
                        ),
                        Container(
                          width: 80.0,
                          margin: EdgeInsets.only(right: 22.0),
                          child: Image.asset(
                            'assets/images/Angry.png', // Path to your image in the assets folder
                            fit: BoxFit.cover, // Adjust the fit as needed (cover, contain, etc.)
                          ),
                        ),
                        Container(
                          width: 80.0,
                          margin: EdgeInsets.only(right: 22.0),
                          child: Image.asset(
                            'assets/images/Sad.png', // Path to your image in the assets folder
                            fit: BoxFit.cover, // Adjust the fit as needed (cover, contain, etc.)
                          ),
                        ),




                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 20.0),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color : Color.fromRGBO(153, 212, 255, 0.5600000023841858),
                        borderRadius: BorderRadius.circular(20.0), // Set the border radius
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Container(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 7, // 70% width
                                child: Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Text(
                                              'Take a Quiz',
                                              style: GoogleFonts.lato(fontSize: 22.0, color: Color(0xFF573926),fontWeight: FontWeight.bold),
                                            ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                                            child: Text(
                                              'Let’s open up to the things that matter the most ',
                                              style: GoogleFonts.lato(fontSize: 17.0, color: Color(0xFF573926)),

                                        ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              print('Text clicked!');
                                            },
                                            child: Text(
                                              'Start the quiz',
                                              style: GoogleFonts.lato(fontSize: 22.0, color: Color(0xFF0289EB),fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                ),
                              ),
                              Expanded(
                                flex: 3, // 30% width
                                child: Container(
                                  child: Center(
                                    child: Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.only(right: 22.0),
                                      child: Image.asset(
                                        'assets/images/Quiz.png', // Path to your image in the assets folder
                                        fit: BoxFit.cover, // Adjust the fit as needed (cover, contain, etc.)
                                      ),
                                    ),                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFFFCDDEC),
                        borderRadius: BorderRadius.circular(20.0), // Set the border radius
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Container(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 7, // 70% width
                                child: Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Text(
                                            'Take a Quiz',
                                            style: GoogleFonts.lato(fontSize: 22.0, color: Color(0xFF86593D),fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                                          child: Text(
                                            'Let’s open up to the things that matter the most ',
                                            style: GoogleFonts.lato(fontSize: 17.0, color: Color(0xFF86593D)),

                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              print('Text clicked!');
                                            },
                                            child: Text(
                                              'Start the quiz',
                                              style: GoogleFonts.lato(fontSize: 22.0, color: Color(0xFF86593D), fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                ),
                              ),
                              Expanded(
                                flex: 3, // 30% width
                                child: Container(
                                  child: Center(
                                    child: Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.only(right: 22.0),
                                      child: Image.asset(
                                        'assets/images/sample.png', // Path to your image in the assets folder
                                        fit: BoxFit.cover, // Adjust the fit as needed (cover, contain, etc.)
                                      ),
                                    ),                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        )



      );
  }
}
