import 'package:flutter/material.dart';
import 'package:tsd_project/bottom_navigation_bar.dart';
import 'package:tsd_project/screen/home_screen.dart';
import 'package:tsd_project/screen/my_account/change_password.dart';
import 'package:tsd_project/screen/my_account/change_username.dart';
import 'package:tsd_project/screen/my_account/edit_personal_details.dart';
import 'package:tsd_project/top_app_bar.dart';
import 'package:tsd_project/user_authentication.dart';

class MyAccount extends StatefulWidget {
  @override
  State<MyAccount> createState() => _MyAccountState();
}

//Get the relavant first name and lastname and display it right to the profile picture

class _MyAccountState extends State<MyAccount> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => checkLoginStatus(context));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        Navigator.push(
            context, (MaterialPageRoute(builder: (context) => HomeScreen())));
      },
      child: Scaffold(
          bottomNavigationBar: CustomBottomNavigationBar(
            initialIndex: 3,
          ),
          appBar: CustomTopAppBar(),
          body: Container(
            color: const Color(0xE51FC0E7),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(children: [
                  Container(
                    height: 100,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.25),
                            offset: Offset(5, 5),
                            blurRadius: 4)
                      ],
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Flexible(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      constraints:
                                          const BoxConstraints(maxWidth: 100),
                                      decoration: const BoxDecoration(
                                        color: Color.fromRGBO(217, 217, 217, 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.elliptical(71, 64)),
                                      ),
                                      child: Image.asset(
                                          "assets/images/profile_img.png"),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        const Expanded(
                            flex: 7,
                            child: Text(
                              'JOHNATHAN HENRY',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Color.fromRGBO(3, 71, 120, 1),
                                  fontSize: 22,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.bold,
                                  height: 1),
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.25),
                            offset: Offset(5, 5),
                            blurRadius: 4)
                      ],
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          //Edit personal details
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 4,
                                    backgroundColor:
                                        Color.fromARGB(255, 232, 230, 230),
                                    foregroundColor: Colors.black,
                                    shadowColor:
                                        const Color.fromRGBO(0, 0, 0, 0.25),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        (MaterialPageRoute(
                                            builder: (context) =>
                                                EditPersonalDetails())));
                                  },
                                  child: SizedBox(
                                      height: 60,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Icon(
                                              Icons.person_2_outlined,
                                              color: Colors.grey[600],
                                              size: 30,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          const Expanded(
                                            flex: 9,
                                            child: Text(
                                              'Edit Personal Details',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      3, 71, 120, 1),
                                                  fontSize: 20,
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.w500,
                                                  height: 1),
                                            ),
                                          )
                                        ],
                                      )),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          //Change the username
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 4,
                                    backgroundColor:
                                        Color.fromARGB(255, 232, 230, 230),
                                    foregroundColor: Colors.black,
                                    shadowColor:
                                        const Color.fromRGBO(0, 0, 0, 0.25),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        (MaterialPageRoute(
                                            builder: (context) =>
                                                ChangeUserUsername())));
                                  },
                                  child: SizedBox(
                                      height: 60,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Icon(
                                              Icons.person_2_sharp,
                                              color: Colors.grey[600],
                                              size: 30,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          const Expanded(
                                            flex: 9,
                                            child: Text(
                                              'Change The Username',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      3, 71, 120, 1),
                                                  fontSize: 20,
                                                  letterSpacing:
                                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                                  fontWeight: FontWeight.w500,
                                                  height: 1),
                                            ),
                                          )
                                        ],
                                      )),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          //Change the password
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 4,
                                    backgroundColor:
                                        Color.fromARGB(255, 232, 230, 230),
                                    foregroundColor: Colors.black,
                                    shadowColor:
                                        const Color.fromRGBO(0, 0, 0, 0.25),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        (MaterialPageRoute(
                                            builder: (context) =>
                                                ChangeUserPassword())));
                                  },
                                  child: SizedBox(
                                      height: 60,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Icon(
                                              Icons.password,
                                              color: Colors.grey[600],
                                              size: 30,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          const Expanded(
                                            flex: 9,
                                            child: Text(
                                              'Change The Password',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      3, 71, 120, 1),
                                                  fontSize: 20,
                                                  letterSpacing:
                                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                                  fontWeight: FontWeight.w500,
                                                  height: 1),
                                            ),
                                          )
                                        ],
                                      )),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          //Close the account
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 4,
                                    backgroundColor:
                                        Color.fromARGB(255, 232, 230, 230),
                                    foregroundColor: Colors.black,
                                    shadowColor:
                                        const Color.fromRGBO(0, 0, 0, 0.25),
                                  ),
                                  onPressed: () {},
                                  child: SizedBox(
                                      height: 60,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Icon(
                                              Icons.delete_forever,
                                              color: Colors.grey[600],
                                              size: 30,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          const Expanded(
                                            flex: 9,
                                            child: Text(
                                              'Close The Account',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      3, 71, 120, 1),
                                                  fontSize: 20,
                                                  letterSpacing:
                                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                                  fontWeight: FontWeight.w500,
                                                  height: 1),
                                            ),
                                          )
                                        ],
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          )),
    );
  }
}
