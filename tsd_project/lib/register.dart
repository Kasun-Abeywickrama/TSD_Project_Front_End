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
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Adding an register image
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/images/register_image.jpg',
                height: 100,
              ),
            ),

            //Adding register text
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'REGISTER',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Color.fromARGB(255, 48, 17, 134)),
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
                      child: TextFormField(
                        controller: usernameController,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          hintText: 'Enter Username',
                          prefixIcon: Icon(Icons.person),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2),
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

                    //First name
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: firstnameController,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          labelText: 'First Name',
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          hintText: 'Enter the first name',
                          prefixIcon: Icon(Icons.person),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                        ),
                        onChanged: (String value) {},
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter the first name";
                          } else if (RegExp(r'\d').hasMatch(value)) {
                            return 'First name cannot contain numbers';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),

                    //Last name
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: lastnameController,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          labelText: 'Last Name',
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          hintText: 'Enter the last name',
                          prefixIcon: Icon(Icons.person),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                        ),
                        onChanged: (String value) {},
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter the last name";
                          } else if (RegExp(r'\d').hasMatch(value)) {
                            return 'Last name cannot contain numbers';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),

                    //Password
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: const InputDecoration(
                          labelText: 'New Password',
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          hintText: 'Enter a new password',
                          prefixIcon: Icon(Icons.password),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2),
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

                    //Submit button
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        onPressed: () {
                          if (_regformKey.currentState!.validate()) {
                            submitForm();
                          }
                        },
                        color: const Color.fromARGB(255, 48, 17, 134),
                        textColor: Colors.white,
                        child: const Text('Register'),
                      ),
                    )
                  ])),
            ),

            //Create the link or button to naviagate to the login form right here.
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Text('Already Registered ? '),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => login_user()));
                    },
                    child: const Text('Login',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        )),
                  ),
                ],
              ),
            )
          ]),
    )));
  }

  //Function of submitting the data
  void submitForm() async {
    //Obtaining the URL to a variable
    final String apiUrl = 'http://10.0.2.2:8000/register/';

    //Mapping the relavant data
    Map<String, dynamic> formData = {
      'username': usernameController.text,
      'password': passwordController.text,
      'firstname': firstnameController.text,
      'lastname': lastnameController.text,
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
        if (errorData['errors']['username']
            .contains('A user with that username already exists.')) {
          print('Username already exists');
          usernameExistsDialog();
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
                side: const BorderSide(
                    color: Color.fromARGB(255, 48, 17, 134), width: 4)),
            title: const Text('Username Already Exists'),
            content: const Text('Please enter an another username'),
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

  //Creating the dialog box to display the successfull login and navigating to login screen
  void loginSuccessDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(
                    color: Color.fromARGB(255, 48, 17, 134), width: 4)),
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
                    style: TextStyle(color: Color.fromARGB(255, 48, 17, 134)),
                  ))
            ],
          );
        });
  }
}
