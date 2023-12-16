import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tsd_project/bottom_navigation_bar.dart';
import 'package:tsd_project/screen/my_account/my_account_page.dart';
import 'package:tsd_project/top_app_bar.dart';
import 'package:tsd_project/user_authentication.dart';

class EditPersonalDetails extends StatefulWidget {
  @override
  State<EditPersonalDetails> createState() => _EditPersonalDetailsState();
}

class _EditPersonalDetailsState extends State<EditPersonalDetails> {
  //Declaring the variable to check if the page is loading
  bool isLoading = true;

  //Form key
  final GlobalKey<FormState> _userDetailsUpdateformKey = GlobalKey<FormState>();

  //Text editing controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobilePhoneController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  //Initializing the flutter secure storage
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  //Function that gets the existing data from the database
  Future<void> setUserDetails() async {
    //This process Fetches the data from the backend
    String? token = await secureStorage.read(key: 'token');
    if (token != null) {
      try {
        // Obtaining the URL to a variable
        final String apiUrl =
            'http://10.0.2.2:8000/send_user_personal_details/';

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
          final Map<String, dynamic> backendUserDetails =
              json.decode(response.body);

          //Intializing these variables and rebuild the build method
          setState(() {
            if (backendUserDetails['user_personal_details']['first_name'] !=
                null) {
              _firstNameController.text =
                  backendUserDetails['user_personal_details']['first_name'];
            }
            if (backendUserDetails['user_personal_details']['last_name'] !=
                null) {
              _lastNameController.text =
                  backendUserDetails['user_personal_details']['last_name'];
            }
            if (backendUserDetails['user_personal_details']['email'] != null) {
              _emailController.text =
                  backendUserDetails['user_personal_details']['email'];
            }
            if (backendUserDetails['user_personal_details']['mobile_number'] !=
                null) {
              _mobilePhoneController.text =
                  backendUserDetails['user_personal_details']['mobile_number'];
            }
            if (backendUserDetails['user_personal_details']['date_of_birth'] !=
                null) {
              _dateController.text =
                  backendUserDetails['user_personal_details']['date_of_birth'];
            }
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
    setUserDetails();
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
                                key: _userDetailsUpdateformKey,
                                child: Column(
                                  children: [
                                    //Edit personal details text
                                    const Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Edit Personal Details',
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
                                    //Displaying the first name text
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "First Name : ",
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
                                    //Displaying the first name form field
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8.0, 0, 8, 15),
                                      child: Container(
                                        constraints: const BoxConstraints(
                                          maxWidth: 450.0,
                                        ),
                                        child: TextFormField(
                                          controller: _firstNameController,
                                          keyboardType: TextInputType.name,
                                          decoration: InputDecoration(
                                            hintText: 'Enter First Name',
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
                                              return "Please enter the first name";
                                            } else if (RegExp(r'\d')
                                                .hasMatch(value)) {
                                              return 'Firstname cannot contain numbers';
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    //Displaying the last name text
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "Last Name : ",
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
                                    //Displaying the last name form field
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8.0, 0, 8, 15),
                                      child: Container(
                                        constraints: const BoxConstraints(
                                          maxWidth: 450.0,
                                        ),
                                        child: TextFormField(
                                          controller: _lastNameController,
                                          keyboardType: TextInputType.name,
                                          decoration: InputDecoration(
                                            hintText: 'Enter Last Name',
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
                                              return "Please enter the lastname";
                                            } else if (RegExp(r'\d')
                                                .hasMatch(value)) {
                                              return 'Lastname cannot contain numbers';
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    //Displaying the email text
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "Email Address : ",
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
                                    //Displaying the email form field
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8.0, 0, 8, 15),
                                      child: Container(
                                        constraints: const BoxConstraints(
                                          maxWidth: 450.0,
                                        ),
                                        child: TextFormField(
                                          controller: _emailController,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            hintText: 'Enter Email Address',
                                            prefixIcon:
                                                const Icon(Icons.email_sharp),
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
                                              return "Please enter the email address";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    //Displaying the mobile phone number text
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "Mobile Number : ",
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
                                    //Displaying the mobile number form field
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8.0, 0, 8, 15),
                                      child: Container(
                                        constraints: const BoxConstraints(
                                          maxWidth: 450.0,
                                        ),
                                        child: TextFormField(
                                          controller: _mobilePhoneController,
                                          keyboardType: TextInputType.phone,
                                          decoration: InputDecoration(
                                            hintText: 'Enter Mobile Number',
                                            prefixIcon: const Icon(Icons.phone),
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
                                              return "Please enter the mobile number";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      ),
                                    ),

                                    //Displaying the date of birth text
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "Date of Birth : ",
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

                                    //Displaying the Date of birth form field
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8.0, 0, 8, 15),
                                      child: Container(
                                        constraints: const BoxConstraints(
                                          maxWidth: 450.0,
                                        ),
                                        child: TextFormField(
                                          controller: _dateController,
                                          onTap: () async {
                                            DateTime? pickedDate =
                                                await showDatePicker(
                                                    context: context,
                                                    firstDate: DateTime(1900),
                                                    lastDate: DateTime.now());

                                            if (pickedDate != null) {
                                              setState(() {
                                                _dateController.text =
                                                    DateFormat("yyyy-MM-dd")
                                                        .format(pickedDate);
                                              });
                                            }
                                          },
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            hintText: 'Select Date of Birth',
                                            prefixIcon: const Icon(
                                                Icons.calendar_month_outlined),
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
                                              return "Please select a birth of date";
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
                                                  if (_userDetailsUpdateformKey
                                                      .currentState!
                                                      .validate()) {
                                                    updateUserPersonalDetails();
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

  Future<void> updateUserPersonalDetails() async {
    //This process sends the data to the backend and update them
    String? token = await secureStorage.read(key: 'token');
    if (token != null) {
      try {
        // Obtaining the URL to a variable
        final String apiUrl =
            'http://10.0.2.2:8000/update_user_personal_details/';

        //Converting the url to uri
        Uri uri = Uri.parse(apiUrl);

        //The data map that must be send to the backend
        Map<String, dynamic> formData = {
          'first_name': _firstNameController.text,
          'last_name': _lastNameController.text,
          'email': _emailController.text,
          'mobile_number': _mobilePhoneController.text,
          'date_of_birth': _dateController.text,
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
        } else {
          print('Failed to submit data ${response.body}');
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
            content:
                const Text('Personal details has been successfully updated'),
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

  @override
  void dispose() {
    // Dispose the controller when the widget is disposed
    _dateController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobilePhoneController.dispose();
    super.dispose();
  }
}
