import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:tsd_project/important_tools/api_endpoints.dart';
import 'package:tsd_project/decoration_tools/top_app_bar.dart';
import 'package:tsd_project/important_tools/user_authentication.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  //Form key
  final GlobalKey<FormState> _changePasswordformKey = GlobalKey<FormState>();

  //Text editing controllers
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => checkLoginStatus(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomTopAppBar(
          pageIndex: 1,
          pageName: "Change Password",
        ),
        body: Container(
          color: Colors.white,
          child: ListView(children: [
            Center(
                child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  Container(
                    constraints: const BoxConstraints(maxWidth: 450),
                    decoration: const BoxDecoration(
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
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Form(
                        key: _changePasswordformKey,
                        child: Column(
                          children: [
                            //Change Password text
                            const Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Change The Password',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color.fromRGBO(3, 71, 120, 1),
                                        fontSize: 25,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.bold,
                                        height: 1),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            //Displaying the current password text
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Current Password : ",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Color.fromRGBO(3, 71, 120, 1),
                                          fontSize: 18,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.bold,
                                          height: 1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //Displaying the current password form field
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 15),
                              child: Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 450.0,
                                ),
                                child: TextFormField(
                                  controller: _currentPasswordController,
                                  keyboardType: TextInputType.text,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: 'Enter the Current Password',
                                    prefixIcon: const Icon(Icons.password),
                                    filled: true,
                                    fillColor: const Color.fromARGB(
                                        255, 232, 230, 230),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              255, 232, 230, 230)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              255, 232, 230, 230)),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 2),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 2),
                                    ),
                                  ),
                                  onChanged: (String value) {},
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter the current password";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ),
                            //Displaying the new password text
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "New Password : ",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Color.fromRGBO(3, 71, 120, 1),
                                          fontSize: 18,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.bold,
                                          height: 1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //Displaying the new password form field
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 15),
                              child: Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 450.0,
                                ),
                                child: TextFormField(
                                  controller: _newPasswordController,
                                  keyboardType: TextInputType.text,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: 'Enter The New Password',
                                    prefixIcon: const Icon(Icons.password),
                                    filled: true,
                                    fillColor: const Color.fromARGB(
                                        255, 232, 230, 230),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              255, 232, 230, 230)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              255, 232, 230, 230)),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 2),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 2),
                                    ),
                                  ),
                                  onChanged: (String value) {},
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter a new password";
                                    } else if (_currentPasswordController
                                            .text ==
                                        _newPasswordController.text) {
                                      return "Please enter a new password";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ),
                            //Displaying the retype new password text
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Retype New Password : ",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Color.fromRGBO(3, 71, 120, 1),
                                          fontSize: 18,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.bold,
                                          height: 1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //Displaying the Retype New password form field
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 15),
                              child: Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 450.0,
                                ),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: 'Retype New Password',
                                    prefixIcon: const Icon(Icons.password),
                                    filled: true,
                                    fillColor: const Color.fromARGB(
                                        255, 232, 230, 230),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              255, 232, 230, 230)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              255, 232, 230, 230)),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 2),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 2),
                                    ),
                                  ),
                                  onChanged: (String value) {},
                                  validator: (value) {
                                    if (value != _newPasswordController.text) {
                                      return "Please retype the new password correctly";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            Row(
                              children: [
                                //Cancel button
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xff66bef4),
                                              Color(0xff2a58e5)
                                            ],
                                            stops: [0.1, 0.6],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(35)),
                                      height: 40,
                                      constraints: const BoxConstraints(
                                        maxWidth: 200.0,
                                      ),
                                      child: MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(35)),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        textColor: Colors.white,
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                //Update button
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xff2a58e5),
                                              Color(0xff66bef4),
                                            ],
                                            stops: [0.25, 0.9],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(35)),
                                      height: 40,
                                      constraints: const BoxConstraints(
                                        maxWidth: 200.0,
                                      ),
                                      child: MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(35)),
                                        onPressed: () {
                                          if (_changePasswordformKey
                                              .currentState!
                                              .validate()) {
                                            updatePassword(context);
                                          }
                                        },
                                        textColor: Colors.white,
                                        child: const Text(
                                          'Update',
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )),
          ]),
        ));
  }

  Future<void> updatePassword(BuildContext context) async {
    loadingDialog();
    //This process sends the data to the backend and update them

    if (context.mounted) {
      if (await checkLoginStatus(context)) {
        try {
          String? accessToken = await retrieveAccessToken();

          // Obtaining the URL to a variable
          String apiUrl = (await ReadApiEndpoints.readApiEndpointsData())["updatePatientAuthUserDetailsEndpoint"];

          //Converting the url to uri
          Uri uri = Uri.parse(apiUrl);

          Map<String, dynamic> newPassword = {
            'password': _newPasswordController.text,
          };

          //The data map that must be send to the backend
          Map<String, dynamic> formData = {
            'current_password': _currentPasswordController.text,
            'patient_auth_user_details': newPassword,
          };

          //Requesting the data from the backend
          final response = await http.post(
            uri,
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            },
            body: json.encode(formData),
          );

          if (response.statusCode == 201) {
            print('Data updated successfully');
            if(context.mounted) {
              Navigator.of(context).pop();
              dataSuccessfullyUpdatedDialogBox();
            }
          } else if (response.statusCode == 401) {
            if(context.mounted) {
              Navigator.of(context).pop();
              incorrectPasswordDialog();
            }
          } else {
            //Decode the response received from the server
            final Map<String, dynamic> errorData = json.decode(response.body);
            print('Failed to submit data : $errorData');
          }
        } catch (e) {
          print('Exception occured: $e');
        }
      }
    }
  }

  void dataSuccessfullyUpdatedDialogBox() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Password Changed',
        text: 'Successfully changed the password',
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
        barrierDismissible: false,
        disableBackBtn: true);
  }

  //Creating the alert dialog box to display invalid credentials
  void incorrectPasswordDialog() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Incorrect Password',
        text: 'Please enter the correct current password');
  }

  //Creating the alert dialog box to display loading
  void loadingDialog() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
        barrierDismissible: false,
        disableBackBtn: true,
        title: 'Submitting',
        text: 'Please wait patiently!');
  }
}
