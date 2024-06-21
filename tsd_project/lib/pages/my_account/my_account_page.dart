import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsd_project/decoration_tools/custom_loading_indicator.dart';
import 'package:tsd_project/important_tools/api_endpoints.dart';
import 'package:tsd_project/pages/my_account/change_password_page.dart';
import 'package:tsd_project/pages/my_account/change_email_page.dart';
import 'package:tsd_project/pages/my_account/edit_personal_details_page.dart';
import 'package:tsd_project/important_tools/user_authentication.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../patient_login_page.dart';

class MyAccountPage extends StatefulWidget {
  //When a new unique key is passed, the widget page will rebuild including the initial process method
  const MyAccountPage({Key? key}) : super(key: key);

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

//Get the relavant first name and lastname and display it right to the profile picture

class _MyAccountPageState extends State<MyAccountPage> {
  //Declaring the variable to check if the page is loading
  bool isLoading = true;

  String email = "";

  //Function that gets the current email from the database
  Future<void> setCurrentEmail(BuildContext context) async {
    //This process Fetches the data from the backend

    if (context.mounted) {
      if (await checkLoginStatus(context)) {
        try {
          String? accessToken = await retrieveAccessToken();

          // Obtaining the URL to a variable
          String apiUrl = (await ReadApiEndpoints.readApiEndpointsData())["requestPatientAuthUserDetailsEndpoint"];

          //Converting the url to uri
          Uri uri = Uri.parse(apiUrl);

          //Requesting the data from the backend
          final response = await http.get(
            uri,
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            },
          );

          if (response.statusCode == 200) {
            //Decode the response
            final Map<String, dynamic> backendUserAuthUserDetails =
                json.decode(response.body);

            if (context.mounted) {
              //Intializing these variables and rebuild the build method
              setState(() {
                email = backendUserAuthUserDetails['patient_auth_user_details']
                    ['username'];
                //Considering the page is loaded
                isLoading = false;
              });
            }
          } else {
            print('Failed to receive data ${response.body}');
          }
        } catch (e) {
          print('Exception occured: $e');
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initialProcess(context);
  }

  Future<void> initialProcess(BuildContext context) async {
    if (await checkLoginStatus(context)) {
      if (context.mounted) {
        setCurrentEmail(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CustomLoadingIndicator()
        : ListView(children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(children: [
                Container(
                  height: 100,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff2a58e5),
                        Color(0xff66bef4),
                      ],
                      stops: [0.25, 0.9],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
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
                                        const BoxConstraints(maxWidth: 75),
                                    child: ClipOval(
                                      child: Container(
                                        color: Colors.white,
                                        height: 100,
                                        width: 100,
                                        child: Image.asset(
                                          "assets/images/myaccount.png",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      Expanded(
                          flex: 7,
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0, 15, 15, 15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  email,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.bold,
                                      height: 1),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    signOutDialog();
                                  },
                                  child: const Text(
                                    'Sign Out',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        letterSpacing: 0,
                                        decoration:
                                            TextDecoration.underline,
                                        decorationColor: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        height: 1),
                                  ),
                                ),
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(255, 5, 43, 157),
                          offset: Offset(5, 5),
                          blurRadius: 20)
                    ],
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
                                  backgroundColor: const Color.fromARGB(
                                      255, 232, 230, 230),
                                  foregroundColor: Colors.black,
                                  shadowColor:
                                      const Color.fromRGBO(0, 0, 0, 0.25),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      (MaterialPageRoute(
                                          builder: (context) =>
                                              EditPersonalDetailsPage())));
                                },
                                child: const SizedBox(
                                    height: 60,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Icon(
                                            Icons.person_2_outlined,
                                            color: Color.fromRGBO(
                                                3, 71, 120, 1),
                                            size: 30,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
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
                                  backgroundColor: const Color.fromARGB(
                                      255, 232, 230, 230),
                                  foregroundColor: Colors.black,
                                  shadowColor:
                                      const Color.fromRGBO(0, 0, 0, 0.25),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      (MaterialPageRoute(
                                          builder: (context) =>
                                              ChangeEmailPage())));
                                },
                                child: const SizedBox(
                                    height: 60,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Icon(
                                            Icons.email,
                                            color: Color.fromRGBO(
                                                3, 71, 120, 1),
                                            size: 30,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                          flex: 9,
                                          child: Text(
                                            'Change Email Address',
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
                                  backgroundColor: const Color.fromARGB(
                                      255, 232, 230, 230),
                                  foregroundColor: Colors.black,
                                  shadowColor:
                                      const Color.fromRGBO(0, 0, 0, 0.25),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      (MaterialPageRoute(
                                          builder: (context) =>
                                              ChangePasswordPage())));
                                },
                                child: const SizedBox(
                                    height: 60,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Icon(
                                            Icons.password,
                                            color: Color.fromRGBO(
                                                3, 71, 120, 1),
                                            size: 30,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
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
                                  backgroundColor: const Color.fromARGB(
                                      255, 232, 230, 230),
                                  foregroundColor: Colors.black,
                                  shadowColor:
                                      const Color.fromRGBO(0, 0, 0, 0.25),
                                ),
                                onPressed: () {
                                  accountDeleteWarningDialog();
                                },
                                child: const SizedBox(
                                    height: 60,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Icon(
                                            Icons.delete_forever,
                                            color: Color.fromRGBO(
                                                3, 71, 120, 1),
                                            size: 30,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
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
        ]);
  }

  //Creating the dialog box to confirm that the user wants to sign out
  void signOutDialog() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        title: 'Are You Sure ?',
        text: 'Sign Out from your account !',
        confirmBtnText: 'Sign Out',
        onConfirmBtnTap: () {
          signOut(context);
        });
  }

  void accountDeleteWarningDialog() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        title: 'Deleting The Account',
        text: 'Deleting your account will permanently erase all the information related to your account. This action cannot be undone !',
        confirmBtnText: 'Delete Account',
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
          deleteAccountDialog();
        });
  }

  void deleteAccountDialog(){
    QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        title: 'Are You Sure ?',
        text: 'Please confirm that you want to delete your account !',
        confirmBtnText: 'Delete',
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
          deleteAccount(context);
        });
  }

  Future<void> deleteAccount(BuildContext context) async{
    loadingDialog();

    if(context.mounted){
      if(await checkLoginStatus(context)){
        try{
          final String? accessToken = await retrieveAccessToken();

          String apiUrl = (await ReadApiEndpoints.readApiEndpointsData())["requestDeleteAccountEndpoint"];

          //Converting the url to uri
          Uri uri = Uri.parse(apiUrl);

          //Requesting the data from the backend
          final response = await http.post(
            uri,
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            },
          );

          if(response.statusCode == 201){
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove('accessToken');
            await prefs.remove('refreshToken');
            if(context.mounted){
              Navigator.of(context).pop();
            }
            accountDeletedDialog();
          }
          else{
            print('Failed to delete account ${response.body}');
          }
        }
        catch(e){
          print("Exception occured : $e");
        }
      }
    }
  }

  void accountDeletedDialog() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Account Deleted',
        disableBackBtn: true,
        barrierDismissible: false,
        text: 'Account Successfully Deleted !',
        onConfirmBtnTap: () {
          if (context.mounted) {
            Navigator.of(context).pop();
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PatientLoginPage()));
          }
        });
  }

  //Creating the alert dialog box to display loading
  void loadingDialog() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
        barrierDismissible: false,
        disableBackBtn: true,
        title: 'Deleting Account',
        text: 'Please wait patiently!');
  }
}
