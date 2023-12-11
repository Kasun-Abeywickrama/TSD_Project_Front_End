import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:tsd_project/quiz_receiver.dart';
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
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(color: Color(0xE51FC0E7)),
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
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'SIGN IN',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.black),
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
                                  prefixIcon: Icon(Icons.person),
                                  filled: true,
                                  fillColor: Colors.white,
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
                                keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  prefixIcon: const Icon(Icons.password),
                                  filled: true,
                                  fillColor: Colors.white,
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
                              height: 45,
                              constraints: const BoxConstraints(
                                maxWidth: 450.0,
                              ),
                              child: MaterialButton(
                                color: Color(0xFF0039FF),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(35)),
                                minWidth: double.infinity,
                                onPressed: () async {
                                  if (_logformKey.currentState!.validate()) {
                                    await submitForm();
                                  }
                                },
                                textColor: Colors.white,
                                child: const Text('Sign In'),
                              ),
                            ),
                          )
                        ])),
                  ),

                  //Create the text or button to navigate to the register form right here.
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text(
                          'Not Yet Registered ? ',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterUser()));
                          },
                          child: const Text('Sign Up',
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

  //Creating the function to send data and receive response
  Future<void> submitForm() async {
    //Getting the url to a variable
    final String apiUrl = 'http://10.0.2.2:8000/login/';

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

          //Storing username and user_id in variables
          final String username = decodedToken['username'];
          final int authUserId = decodedToken['auth_user_id'];

          print('Username: $username');
          print('Auth_user_id: $authUserId');

          //Setting the username and user_id in secure storage
          secureStorage.write(key: 'username', value: username);
          secureStorage.write(
              key: 'auth_user_id', value: authUserId.toString());

          //Navigate to the Home page
          Navigator.push(context,
              (MaterialPageRoute(builder: (context) => Quiz_Receiver())));
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

  //Creating the alert dialog box to display invalid credentials
  void invalidCredentialsDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(
                    color: Color.fromARGB(255, 48, 17, 134), width: 4)),
            title: const Text('Invalid Credentials'),
            content: const Text('Please enter the valid username and password'),
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
}
