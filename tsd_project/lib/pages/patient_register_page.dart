import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:tsd_project/important_tools/api_endpoints.dart';
import 'package:tsd_project/pages/patient_login_page.dart';

//Creating the patient registration page for the mobile application

//Created the stateless widget and then converted it into a stateful widget.
class PatientRegisterPage extends StatefulWidget {
  @override
  State<PatientRegisterPage> createState() => _PatientRegisterPageState();
}

class _PatientRegisterPageState extends State<PatientRegisterPage> {
  //Declaring the form key to validate the fields
  final GlobalKey<FormState> _regformKey = GlobalKey<FormState>();

  //Creating text editing controllers for the form fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController retypePasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        SystemNavigator.pop(); // Close the entire app
      },
      child: Scaffold(
          body: Container(
        decoration: const BoxDecoration(color: Colors.white),
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
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: GradientText(
                        'SIGN UP',
                        style: const TextStyle(
                            fontSize: 40.0, fontWeight: FontWeight.bold),
                        colors: const [
                          Color(0xff2a58e5),
                          Color.fromARGB(255, 47, 153, 219),
                          Color(0xff2a58e5),
                        ],
                      ),
                    ),

                    //Creating the register form
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                          key: _regformKey,
                          child: Column(children: [
                            //Email
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 450.0,
                                ),
                                child: TextFormField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: 'Email Address',
                                    prefixIcon: const Icon(Icons.email),
                                    filled: true,
                                    fillColor:
                                        const Color.fromARGB(255, 197, 218, 240),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide:
                                          const BorderSide(color: Colors.white),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide:
                                          const BorderSide(color: Colors.white),
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
                                      return "Please enter an email address";
                                    } else if (!EmailValidator.validate(value)) {
                                      return "Please enter a valid email address";
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
                                  keyboardType: TextInputType.text,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: 'New Password',
                                    prefixIcon: const Icon(Icons.password),
                                    filled: true,
                                    fillColor:
                                        Color.fromARGB(255, 197, 218, 240),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide:
                                          const BorderSide(color: Colors.white),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide:
                                          const BorderSide(color: Colors.white),
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
                                  keyboardType: TextInputType.text,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: 'Retype Password',
                                    prefixIcon: const Icon(Icons.password),
                                    filled: true,
                                    fillColor:
                                        Color.fromARGB(255, 197, 218, 240),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide:
                                          const BorderSide(color: Colors.white),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide:
                                          const BorderSide(color: Colors.white),
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
                                      return "Please retype the password";
                                    } else if (passwordController.text !=
                                        value) {
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
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(35),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xff66bef4),
                                        Color(0xff2a58e5)
                                      ],
                                      stops: [0.25, 0.6],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )),
                                height: 45,
                                constraints: const BoxConstraints(
                                  maxWidth: 450.0,
                                ),
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(35)),
                                  minWidth: double.infinity,
                                  onPressed: () {
                                    if (_regformKey.currentState!.validate()) {
                                      submitForm(context);
                                    }
                                  },
                                  textColor: Colors.white,
                                  child: const Text('Register',
                                      style: TextStyle(fontSize: 17)),
                                ),
                              ),
                            )
                          ])),
                    ),

                    //Create the link or button to navigate to the login form right here.
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
                      child: Column(
                        children: [
                          GradientText(
                            'Already Registered ? ',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                            colors: const [
                              Color(0xff2a58e5),
                              Color.fromARGB(255, 47, 153, 219),
                              Color(0xff2a58e5),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PatientLoginPage()));
                            },
                            child: GradientText(
                              'Sign In',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  decorationThickness: 1.5,
                                  decorationColor: Colors.blue),
                              colors: const [
                                Color(0xff2a58e5),
                                Color.fromARGB(255, 47, 153, 219),
                                Color(0xff2a58e5),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          )),
        ),
      )),
    );
  }

  //Function of submitting the data
  void submitForm(BuildContext context) async {
    loadingDialog();
    if (context.mounted) {
      try {
        //Obtaining the URL to a variable
        String apiUrl = (await ReadApiEndpoints.readApiEndpointsData())["registerEndpoint"];

        //Mapping the relavant data
        Map<String, dynamic> auth_user = {
          'username': emailController.text.toLowerCase(),
          'password': passwordController.text,
        };

        Map<String, dynamic> patient = {};

        Map<String, dynamic> formData = {
          'auth_user': auth_user,
          'patient': patient,
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
          if(context.mounted) {
            Navigator.of(context).pop();
            loginSuccessDialog();
          }
          //If status code is not 201
        } else {
          //Decode the response received from the server
          final Map<String, dynamic> errorData = json.decode(response.body);
          //If the error is email uniqueness
          if (errorData['errors'].containsKey('username')) {
            if (errorData['errors']['username']
                .contains('A user with that username already exists.')) {
              print('Email already exists');
              if(context.mounted) {
                Navigator.of(context).pop();
                emailExistsDialog();
              }
            } else {
              print('$errorData');
            }
          }
          //If it is not
          else {
            print('$errorData');
          }
        }
      } catch (e) {
        print("Exception Occured: $e");
      }
    }
  }

  //Creating the alert dialog box to display username already exists
  void emailExistsDialog() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        title: 'Email Already Exists',
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
        },
        text: 'Please enter another email');
  }

  //Creating the dialog box to display the successfull login and navigating to login screen
  void loginSuccessDialog() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        title: 'Successfully Signed Up',
        text: 'Please Sign In',
        confirmBtnText: 'Sign In',
        cancelBtnText: 'Cancel',
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
          Navigator.pushReplacement(
              context, (MaterialPageRoute(builder: (context) => PatientLoginPage())));
        });
  }

  //Creating the alert dialog box to display loading
  void loadingDialog() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
        barrierDismissible: false,
        disableBackBtn: true,
        title: 'Signing Up',
        text: 'Please wait patiently!');
  }
}
