import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:tsd_project/decoration_tools/top_app_bar.dart';
import 'package:tsd_project/screen/home_screen.dart';
import 'package:tsd_project/screen/my_account/my_account_page.dart';
import 'package:tsd_project/screen/previous_quiz_results.dart';

//This is the main screen
//This screen contains four bodies (for now three)
//This is a single page, when pressed a button in bottom navigation bar,
//The setState will be executed and the body of that related index will be displayed
//The same logic will be applied to top app bar too, the top app bar related to the index will be displayed
//Home screen index = 0
//Previous quiz results page index = 2
//My account page index = 3


class MainScreen extends StatefulWidget{
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int mainPageIndex = 0; //Home screen index will be the default index

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        if(mainPageIndex == 0){
          closeAppDialog();
        }
        else {
          if(context.mounted){
            setState(() {
              mainPageIndex = 0;
            });
          }
        }
      },
      child: Scaffold(
        //Generating the top app bar for the main screen pages
        appBar:
          mainPageIndex == 0 ?
            CustomTopAppBar(
              pageName: "Home",
              pageIndex: 0,)
          : ( mainPageIndex == 2 ?
            CustomTopAppBar(
              pageName: "Previous Results",
              pageIndex: 0,)
            : CustomTopAppBar(
              pageName: "My Account",
              pageIndex: 0,
          )
          ),
        bottomNavigationBar:
          Padding(
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
                    if (index != mainPageIndex) {
                      if (index == 0) {
                        if(context.mounted){
                        setState(() {
                          mainPageIndex = 0;
                        });
                        }
                      }
                      if (index == 2) {
                        if(context.mounted){
                          setState(() {
                            mainPageIndex = 2;
                          });
                        }
                      }
                      if (index == 3) {
                        if(context.mounted){
                          setState(() {
                            mainPageIndex = 3;
                          });
                        }
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
                  selectedIndex: mainPageIndex,
                ),
              ),
            ),
          ),

        body: mainPageIndex == 0 ?
                const HomeScreen()
            : ( mainPageIndex == 2 ?
                PreviousQuizResults()
            : MyAccount()
        ),
      ),
    );
  }

  //Creating the dialog box to confirm that the user wants to quit the app
  void closeAppDialog() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        title: 'Are You Sure ?',
        text: 'Do you want to quit the application ?',
        confirmBtnText: 'Quit',
        onConfirmBtnTap: () {
          SystemNavigator.pop();
        });
  }
}