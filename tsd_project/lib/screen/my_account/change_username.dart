import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tsd_project/bottom_navigation_bar.dart';
import 'package:tsd_project/screen/my_account/my_account_page.dart';
import 'package:tsd_project/top_app_bar.dart';
import 'package:tsd_project/user_authentication.dart';

class ChangeUserUsername extends StatefulWidget {
  @override
  State<ChangeUserUsername> createState() => _ChangeUserUsernameState();
}

class _ChangeUserUsernameState extends State<ChangeUserUsername> {
  //Declaring the variable to check if the page is loading
  bool isLoading = true;

  //Form key
  final GlobalKey<FormState> _changeUsernameformKey = GlobalKey<FormState>();

  //Text editing controllers
  final TextEditingController _currentUsernameController =
      TextEditingController();
  final TextEditingController _newUsernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //Initializing the flutter secure storage
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  //Function that gets the current username from the database
  Future<void> setCurrentUsername() async {
    //This process Fetches the data from the backend
    String? token = await secureStorage.read(key: 'token');
    if (token != null) {
      try {
        // Obtaining the URL to a variable
        final String apiUrl =
            'http://10.0.2.2:8000/send_user_auth_user_details/';

        //Converting the url to uri
        Uri uri = Uri.parse(apiUrl);

        //Requesting the data from the backend
        final response = await http.get(
          uri,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          //Decode the response
          final Map<String, dynamic> backendUserAuthUserDetails =
              json.decode(response.body);

          //Intializing these variables and rebuild the build method
          setState(() {
            _currentUsernameController.text =
                backendUserAuthUserDetails['user_auth_user_details']
                    ['username'];
            //Considering the page is loaded
            isLoading = false;
          });
        } else {
          print('Failed to receive data ${response.body}');
        }
      } catch (e) {
        print('Exception occured: $e');
      }
    } else {
      print('Token is null');
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => checkLoginStatus(context));
    setCurrentUsername();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CustomBottomNavigationBar(
          initialIndex: 3,
        ),
        appBar: CustomTopAppBar(),
        body: isLoading
            ? Container(
                color: const Color(0xE51FC0E7),
                child: const Center(
                  child: SizedBox(
                      height: 12.0,
                      width: 200.0,
                      child: LinearProgressIndicator(
                          color: Color.fromRGBO(0, 57, 255, 0.8))),
                ),
              )
            : Container(
                color: const Color(0xE51FC0E7),
                child: CustomScrollView(slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
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
                                    color: Color.fromRGBO(0, 0, 0, 0.25),
                                    offset: Offset(5, 5),
                                    blurRadius: 4)
                              ],
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Form(
                                key: _changeUsernameformKey,
                                child: Column(
                                  children: [
                                    //Change Username text
                                    const Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Change The Username',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    3, 71, 120, 1),
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
                                    //Displaying the current username text
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "Current Username : ",
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
                                    //Displaying the current username form field (uneditable field)
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8.0, 0, 8, 15),
                                      child: Container(
                                        constraints: const BoxConstraints(
                                          maxWidth: 450.0,
                                        ),
                                        child: TextFormField(
                                          controller:
                                              _currentUsernameController,
                                          readOnly: true,
                                          keyboardType: TextInputType.name,
                                          decoration: InputDecoration(
                                            prefixIcon:
                                                const Icon(Icons.person),
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
                                    //Displaying the new username text
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "New Username : ",
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
                                    //Displaying the new username form field
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8.0, 0, 8, 15),
                                      child: Container(
                                        constraints: const BoxConstraints(
                                          maxWidth: 450.0,
                                        ),
                                        child: TextFormField(
                                          controller: _newUsernameController,
                                          keyboardType: TextInputType.name,
                                          decoration: InputDecoration(
                                            hintText: 'Enter The New Username',
                                            prefixIcon:
                                                const Icon(Icons.person),
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
                                              return "Please enter the new username";
                                            } else if (RegExp(r'\d')
                                                .hasMatch(value)) {
                                              return 'username cannot contain numbers';
                                            } else {
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
                                              height: 40,
                                              constraints: const BoxConstraints(
                                                maxWidth: 200.0,
                                              ),
                                              child: MaterialButton(
                                                color: Color(0xFF0039FF),
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
                                                  style:
                                                      TextStyle(fontSize: 17),
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
                                              height: 40,
                                              constraints: const BoxConstraints(
                                                maxWidth: 200.0,
                                              ),
                                              child: MaterialButton(
                                                color: Color(0xFF0039FF),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            35)),
                                                onPressed: () {
                                                  if (_changeUsernameformKey
                                                      .currentState!
                                                      .validate()) {
                                                    updateUsername();
                                                  }
                                                },
                                                textColor: Colors.white,
                                                child: const Text(
                                                  'Update',
                                                  style:
                                                      TextStyle(fontSize: 17),
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
                  ),
                ]),
              ));
  }

  Future<void> updateUsername() async {
    //This process sends the data to the backend and update them
    String? token = await secureStorage.read(key: 'token');
    if (token != null) {
      try {
        // Obtaining the URL to a variable
        final String apiUrl =
            'http://10.0.2.2:8000/update_user_auth_user_details/';

        //Converting the url to uri
        Uri uri = Uri.parse(apiUrl);

        Map<String, dynamic> newUsername = {
          'username': _newUsernameController.text,
        };

        //The data map that must be send to the backend
        Map<String, dynamic> formData = {
          'current_password': _passwordController.text,
          'user_auth_user_details': newUsername,
        };

        //Requesting the data from the backend
        final response = await http.post(
          uri,
          headers: {
            'Authorization': 'Bearer $token',
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
          //If the error is username uniqueness
          if (errorData['errors'].containsKey('username')) {
            if (errorData['errors']['username']
                .contains('A user with that username already exists.')) {
              print('Username already exists');
              usernameExistsDialog();
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
    } else {
      print('Token is null');
    }
  }

  void dataSuccessfullyUpdatedDialogBox() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFF0039FF), width: 5)),
            title: const Text('Successfully Updated'),
            content: const Text('Username has been successfully updated'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        (MaterialPageRoute(builder: (context) => MyAccount())));
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Color(0xFF0039FF)),
                  ))
            ],
          );
        });
  }

  //Creating the alert dialog box to display invalid credentials
  void incorrectPasswordDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(
                    color: Color.fromARGB(255, 48, 17, 134), width: 4)),
            title: const Text('Incorrect Password'),
            content: const Text('Please enter the correct password'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Color.fromARGB(255, 48, 17, 134)),
                  ))
            ],
          );
        });
  }

  //Creating the alert dialog box to display username already exists
  void usernameExistsDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFF0039FF), width: 5)),
            title: const Text('Username Already Exists'),
            content: const Text('Please enter an another username'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      color: Color(0xFF0039FF),
                    ),
                  ))
            ],
          );
        });
  }
}
