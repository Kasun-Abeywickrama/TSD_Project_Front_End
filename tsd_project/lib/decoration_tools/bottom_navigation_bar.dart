import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:tsd_project/screen/home_screen.dart';
import 'package:tsd_project/screen/my_account/my_account_page.dart';
import 'package:tsd_project/screen/previous_quiz_results.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int initialIndex;

  CustomBottomNavigationBar({Key? key, this.initialIndex = 0})
      : super(key: key);

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: const LinearGradient(
              colors: [
                Color(0xff66bef4),
                Color(0xff2a58e5),
              ],
              stops: [0.25, 0.6],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: GNav(
            gap: 8,
            color: Colors.white,
            activeColor: Colors.blueAccent[700],
            tabBackgroundColor: const Color.fromARGB(202, 255, 255, 255),
            padding: const EdgeInsets.all(10),
            onTabChange: (index) {
              if (index != widget.initialIndex) {
                if (index == 0) {
                  Navigator.push(
                      context,
                      (MaterialPageRoute(
                          builder: (context) => const HomeScreen())));
                }
                if (index == 2) {
                  Navigator.push(
                      context,
                      (MaterialPageRoute(
                          builder: (context) => PreviousQuizResults())));
                }
                if (index == 3) {
                  Navigator.push(context,
                      (MaterialPageRoute(builder: (context) => MyAccount())));
                }
              }
            },
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.favorite_border,
                text: 'Likes',
              ),
              GButton(
                icon: Icons.quiz_rounded,
                text: 'Results',
              ),
              GButton(
                icon: Icons.account_circle,
                text: 'Account',
              ),
            ],
            selectedIndex: widget.initialIndex,
          ),
        ),
      ),
    );
  }
}
