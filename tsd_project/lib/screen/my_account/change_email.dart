import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:tsd_project/decoration_tools/custom_loading_indicator.dart';
import 'package:tsd_project/important_tools/api_endpoints.dart';
import 'package:tsd_project/decoration_tools/top_app_bar.dart';
import 'package:tsd_project/important_tools/user_authentication.dart';

class ChangeUserEmail extends StatefulWidget {
  @override
  State<ChangeUserEmail> createState() => _ChangeUserEmailState();
}

class _ChangeUserEmailState extends State<ChangeUserEmail> {
  //Declaring the variable to check if the page is loading
  bool isLoading = true;

  //Form key
  final GlobalKey<FormState> _changeEmailformKey = GlobalKey<FormState>();

  //Text editing controllers
  final TextEditingController _currentEmailController =
      TextEditingController();
  final TextEditingController _newEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //Initializing the flutter secure storage
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  //Function that gets the current email from the database
  Future<void> setCurrentEmail(BuildContext context) async {
    //This process Fetches the data from the backend
    String? accessToken = await secureStorage.read(key: 'accessToken');

    if (context.mounted) {
      if (await checkLoginStatus(context)) {
        try {
          // Obtaining the URL to a variable
          const String apiUrl = requestUserAuthUserDetailsEndpoint;

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
                _currentEmailController.text =
                    backendUserAuthUserDetails['user_auth_user_details']
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
    return Scaffold(
        appBar: CustomTopAppBar(
          pageIndex: 1,
          pageName: "Change Email Address",
        ),
        body: isLoading
            ? CustomLoadingIndicator()
            : Container(
                color: Colors.white,
                child: ListView(children: [
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      children: [
                        Container(
                          constraints: BoxConstraints(maxWidth: 450),
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
                            padding: EdgeInsets.all(15.0),
                            child: Form(
                              key: _changeEmailformKey,
                              child: Column(
                                children: [
                                  //Change Email text
                                  const Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Change Email Address',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color:
                                                  Color.fromRGBO(3, 71, 120, 1),
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
                                  //Displaying the current email text
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Current Email Address : ",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    3, 71, 120, 1),
                                                fontSize: 18,
                                                letterSpacing: 0,
                                                fontWeight: FontWeight.bold,
                                                height: 1),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  //Displaying the current email form field (uneditable field)
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        8.0, 0, 8, 15),
                                    child: Container(
                                      constraints: const BoxConstraints(
                                        maxWidth: 450.0,
                                      ),
                                      child: TextFormField(
                                        controller: _currentEmailController,
                                        readOnly: true,
                                        keyboardType: TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(Icons.email),
                                          filled: true,
                                          fillColor: const Color.fromARGB(
                                              255, 232, 230, 230),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 232, 230, 230)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 232, 230, 230)),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: const BorderSide(
                                                color: Colors.red, width: 2),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            borderSide: const BorderSide(
                                                color: Colors.red, width: 2),
                                          ),
                                        ),
                                        onChanged: (String value) {},
                                      ),
                                    ),
                                  ),
                                  //Displaying the new email text
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "New Email Address : ",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    3, 71, 120, 1),
                                                fontSize: 18,
                                                letterSpacing: 0,
                                                fontWeight: FontWeight.bold,
                                                height: 1),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  //Displaying the new email form field
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        8.0, 0, 8, 15),
                                    child: Container(
                                      constraints: const BoxConstraints(
                                        maxWidth: 450.0,
                                      ),
                                      child: TextFormField(
                                        controller: _newEmailController,
                                        keyboardType: TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          hintText: 'Enter New Email Address',
                                          prefixIcon: const Icon(Icons.email),
                                          filled: true,
                                          fillColor: const Color.fromARGB(
                                              255, 232, 230, 230),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 232, 230, 230)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 232, 230, 230)),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            borderSide: const BorderSide(
                                                color: Colors.red, width: 2),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            borderSide: const BorderSide(
                                                color: Colors.red, width: 2),
                                          ),
                                        ),
                                        onChanged: (String value) {},
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Please enter a email address";
                                          } else if (!EmailValidator.validate(value)) {
                                            return "Please enter a valid email address";
                                          } else if(_currentEmailController.text == _newEmailController.text){
                                            return "Please enter a new email address";
                                          }
                                          else {
                                            return null;
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  //Displaying the password text
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Password : ",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    3, 71, 120, 1),
                                                fontSize: 18,
                                                letterSpacing: 0,
                                                fontWeight: FontWeight.bold,
                                                height: 1),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  //Displaying the password form field
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        8.0, 0, 8, 15),
                                    child: Container(
                                      constraints: const BoxConstraints(
                                        maxWidth: 450.0,
                                      ),
                                      child: TextFormField(
                                        controller: _passwordController,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        decoration: InputDecoration(
                                          hintText: 'Enter The Password',
                                          prefixIcon:
                                              const Icon(Icons.password),
                                          filled: true,
                                          fillColor: const Color.fromARGB(
                                              255, 232, 230, 230),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 232, 230, 230)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 232, 230, 230)),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            borderSide: const BorderSide(
                                                color: Colors.red, width: 2),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            borderSide: const BorderSide(
                                                color: Colors.red, width: 2),
                                          ),
                                        ),
                                        onChanged: (String value) {},
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Please enter the password";
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
                                                      BorderRadius.circular(
                                                          35)),
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
                                                      BorderRadius.circular(
                                                          35)),
                                              onPressed: () {
                                                if (_changeEmailformKey
                                                    .currentState!
                                                    .validate()) {
                                                  updateEmail(context);
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

  Future<void> updateEmail(BuildContext context) async {
    //This process sends the data to the backend and update them
    String? accessToken = await secureStorage.read(key: 'accessToken');

    if (context.mounted) {
      if (await checkLoginStatus(context)) {
        try {
          // Obtaining the URL to a variable
          const String apiUrl = updateUserAuthUserDetailsEndpoint;

          //Converting the url to uri
          Uri uri = Uri.parse(apiUrl);

          Map<String, dynamic> newEmail = {
            'username': _newEmailController.text.toLowerCase(),
          };

          //The data map that must be send to the backend
          Map<String, dynamic> formData = {
            'current_password': _passwordController.text,
            'user_auth_user_details': newEmail,
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
            dataSuccessfullyUpdatedDialogBox();
          } else if (response.statusCode == 401) {
            incorrectPasswordDialog();
          } else {
            //Decode the response received from the server
            final Map<String, dynamic> errorData = json.decode(response.body);
            //If the error is email uniqueness
            if (errorData['errors'].containsKey('username')) {
              if (errorData['errors']['username']
                  .contains('A user with that username already exists.')) {
                print('Email already exists');
                emailExistsDialog();
              }
              //If it is not
              else {
                print('Failed to submit data : $errorData');
              }
            }
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
        title: 'Email Address Changed',
        text: 'Successfully changed the email address',
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
        text: 'Please enter the correct password');
  }

  //Creating the alert dialog box to display username already exists
  void emailExistsDialog() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        title: 'Email Address Already Exists',
        text: 'Please enter another email address');
  }
}
