import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tsd_project/login.dart';

//Creating the user registration page for the mobile application

//Created the stateless widget and then converted it into a stateful widget.
class RegisterUser extends StatefulWidget {
  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  //Declaring the form key to validate the fields
  final GlobalKey<FormState> _regformKey = GlobalKey<FormState>();

  //Creating text editing controllers for the form fields
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController retypePasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(color: Color(0xE51FC0E7)),
      child: Center(
        child: SingleChildScrollView(
            child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 2, 0, 16),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Adding register text
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'SIGN UP',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.black),
                    ),
                  ),

                  //Creating the register form
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                        key: _regformKey,
                        child: Column(children: [
                          //Username
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              constraints: const BoxConstraints(
                                maxWidth: 450.0,
                              ),
                              child: TextFormField(
                                controller: usernameController,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  hintText: 'Username',
                                  prefixIcon: Icon(Icons.person),
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide:
                                        BorderSide(color: Colors.red, width: 2),
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
                                    return "Please enter a username";
                                  } else if (RegExp(r'\d').hasMatch(value)) {
                                    return 'Username cannot contain numbers';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                          ),

                          //Password
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              constraints: const BoxConstraints(
                                maxWidth: 450.0,
                              ),
                              child: TextFormField(
                                controller: passwordController,
                                keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                  hintText: 'New Password',
                                  prefixIcon: Icon(Icons.password),
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide:
                                        BorderSide(color: Colors.red, width: 2),
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
                                    return "Please enter a password";
                                  } else if (value.length < 8) {
                                    return "Password must contain at least 8 digits";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                          ),

                          //Retype Password
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              constraints: const BoxConstraints(
                                maxWidth: 450.0,
                              ),
                              child: TextFormField(
                                controller: retypePasswordController,
                                keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                  hintText: 'Retype Password',
                                  prefixIcon: Icon(Icons.password),
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide:
                                        BorderSide(color: Colors.red, width: 2),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 2),
                                  ),
                                ),
                                onChanged: (String value) {},
                                validator: (value) {
                                  if (passwordController.text != value) {
                                    return 'Please correctly retype the password';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                          ),

                          //Submit button
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 45,
                              constraints: const BoxConstraints(
                                maxWidth: 450.0,
                              ),
                              child: MaterialButton(
                                color: Color(0xFF0039FF),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(35)),
                                minWidth: double.infinity,
                                onPressed: () {
                                  if (_regformKey.currentState!.validate()) {
                                    submitForm();
                                  }
                                },
                                textColor: Colors.white,
                                child: const Text('Register'),
                              ),
                            ),
                          )
                        ])),
                  ),

                  //Create the link or button to naviagate to the login form right here.
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text(
                          'Already Registered ? ',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => login_user()));
                          },
                          child: const Text('Sign In',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white)),
                        ),
                      ],
                    ),
                  )
                ]),
          ),
        )),
      ),
    ));
  }

  //Function of submitting the data
  void submitForm() async {
    //Obtaining the URL to a variable
    final String apiUrl = 'http://10.0.2.2:8000/register/';

    //Mapping the relavant data
    Map<String, dynamic> auth_user = {
      'username': usernameController.text,
      'password': passwordController.text,
    };

    Map<String, dynamic> user = {};

    Map<String, dynamic> formData = {
      'auth_user': auth_user,
      'user': user,
    };

    //Converting the url to uri
    Uri uri = Uri.parse(apiUrl);

    //Sending the data to the backend
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(formData),
    );

    //Returning an output according to the status code
    if (response.statusCode == 201) {
      print('Data submitted successfully');
      //Displaying a successfull login dialog box and navigating to login screen through it
      loginSuccessDialog();
      //If status code is not 201
    } else {
      try {
        //Decode the response received from the server
        final Map<String, dynamic> errorData = json.decode(response.body);
        //If the error is username uniqueness
        if (errorData['errors'].containsKey('username')) {
          if (errorData['errors']['username']
              .contains('A user with that username already exists.')) {
            print('Username already exists');
            usernameExistsDialog();
          } else {
            print('$errorData');
          }
        }
        //If it is not
        else {
          print('$errorData');
        }
      } catch (e) {
        print('Error converting to JSON : $e');
      }
    }
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

  //Creating the dialog box to display the successfull login and navigating to login screen
  void loginSuccessDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFF0039FF), width: 5)),
            title: const Text('Successfully Registered'),
            content: const Text('Please Log In'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        (MaterialPageRoute(
                            builder: (context) => login_user())));
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Color(0xFF0039FF)),
                  ))
            ],
          );
        });
  }
}
