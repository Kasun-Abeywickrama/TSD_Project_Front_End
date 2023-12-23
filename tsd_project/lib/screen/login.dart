import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:tsd_project/important_tools/api_endpoints.dart';
import 'package:tsd_project/screen/home_screen.dart';

import 'package:tsd_project/screen/register.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class login_user extends StatefulWidget {
  @override
  State<login_user> createState() => _login_userState();
}

class _login_userState extends State<login_user> {
  //Declaring the form key to validate the fields
  final GlobalKey<FormState> _logformKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //Creating a Flutter secure storage
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

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
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Adding login text
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GradientText(
                        'SIGN IN',
                        style: const TextStyle(
                            fontSize: 40.0, fontWeight: FontWeight.bold),
                        colors: const [
                          Color(0xff2a58e5),
                          Color.fromARGB(255, 47, 153, 219),
                          Color(0xff2a58e5),
                        ],
                      ),
                    ),

                    //Adding the Form
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                          key: _logformKey,
                          child: Column(children: [
                            //username
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 450.0),
                                child: TextFormField(
                                  controller: usernameController,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    labelStyle: const TextStyle(
                                      color: Colors.black,
                                    ),
                                    hintText: 'Username',
                                    prefixIcon: const Icon(Icons.person),
                                    filled: true,
                                    fillColor: const Color.fromARGB(
                                        255, 197, 218, 240),
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
                                      return 'Please enter a valid username';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ),

                            //password
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
                                    hintText: 'Password',
                                    prefixIcon: const Icon(Icons.password),
                                    filled: true,
                                    fillColor: const Color.fromARGB(
                                        255, 197, 218, 240),
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
                                      return 'Please enter a valid password';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ),

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
                                  onPressed: () async {
                                    if (_logformKey.currentState!.validate()) {
                                      await submitForm(context);
                                    }
                                  },
                                  textColor: Colors.white,
                                  child: const Text(
                                    'Sign In',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                              ),
                            )
                          ])),
                    ),

                    //Create the text or button to navigate to the register form right here.
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
                      child: Column(
                        children: [
                          GradientText(
                            'Not Yet Registered ? ',
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
                                      builder: (context) => RegisterUser()));
                            },
                            child: GradientText(
                              'Sign Up',
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
                    )
                  ]),
            ),
          )),
        ),
      )),
    );
  }

  //Creating the function to send data and receive response
  Future<void> submitForm(BuildContext context) async {
    if (context.mounted) {
      //Getting the url to a variable
      const String apiUrl = loginEndpoint;

      //Map the data into a dictionary
      Map<String, dynamic> formData = {
        'username': usernameController.text,
        'password': passwordController.text,
      };

      //Converting url to uri
      Uri uri = Uri.parse(apiUrl);

      //Sending the data to the backend as json and getting the response
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(formData),
      );

      //Displaying a return statement according to the response
      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> responseData = json.decode(response.body);

          final String? token = responseData['token'];

          if (token != null) {
            //Setting the token in secure storage
            secureStorage.write(key: 'token', value: token);

            //Decoding the token data
            final Map<String, dynamic> decodedToken = Jwt.parseJwt(token);

            //Storing auth_user_id in a variable
            final int authUserId = decodedToken['auth_user_id'];

            print('Auth_user_id: $authUserId');

            //Setting the auth_user_id in secure storage
            secureStorage.write(
                key: 'auth_user_id', value: authUserId.toString());

            if (context.mounted) {
              //Navigate to the Home page
              Navigator.pushReplacement(
                  context,
                  (MaterialPageRoute(
                      builder: (context) => const HomeScreen())));
            }
          } else {
            print('Token is null');
          }
        } catch (e) {
          print('Unable to convert from JSON: $e');
        }
      }
      //If the authentication fails
      else if (response.statusCode == 401) {
        print('Invalid credentials');
        invalidCredentialsDialog();
      }
      //If there is an other type of error
      else {
        try {
          //Mapping the response data
          final Map<String, dynamic> responseData = json.decode(response.body);
          //Printing the response data
          print('$responseData');
        } catch (e) {
          print('Error converting to JSON : $e');
        }
      }
    }
  }

  //Creating the alert dialog box to display invalid credentials
  void invalidCredentialsDialog() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Invalid Credentials',
        text: 'Please enter correct credentials');
  }
}
