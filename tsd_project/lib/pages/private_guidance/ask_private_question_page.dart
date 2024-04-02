import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:tsd_project/important_tools/api_endpoints.dart';
import 'package:tsd_project/decoration_tools/top_app_bar.dart';
import 'package:tsd_project/important_tools/user_authentication.dart';

class AskPrivateQuestionPage extends StatefulWidget {
  final int adminId;
  final String counselorFirstName;
  final String counselorLastName;

  AskPrivateQuestionPage(
      {super.key,
      required this.adminId,
      required this.counselorFirstName,
      required this.counselorLastName});

  @override
  State<AskPrivateQuestionPage> createState() => _AskPrivateQuestionPageState();
}

class _AskPrivateQuestionPageState extends State<AskPrivateQuestionPage> {
  //Form key
  final GlobalKey<FormState> _askPrivateQuestionformKey =
      GlobalKey<FormState>();

  //Text editing controllers
  final TextEditingController _privateQuestionController =
      TextEditingController();
  final TextEditingController _counselorNameController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => checkLoginStatus(context));
    _counselorNameController.text =
        "${widget.counselorFirstName} ${widget.counselorLastName}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomTopAppBar(
          pageIndex: 1,
          pageName: "Request Guidance",
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
                        key: _askPrivateQuestionformKey,
                        child: Column(
                          children: [
                            //request guidance text
                            const Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Request Guidance',
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
                            //Displaying the counselor name text
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Counselor : ",
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
                            //Displaying the couselor name form field
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 15),
                              child: Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 450.0,
                                ),
                                child: TextFormField(
                                  controller: _counselorNameController,
                                  keyboardType: TextInputType.name,
                                  readOnly: true,
                                  decoration: InputDecoration(
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
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              255, 232, 230, 230)),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 2),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 2),
                                    ),
                                  ),
                                  onChanged: (String value) {},
                                ),
                              ),
                            ),

                            //Displaying the private question text
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "The Question : ",
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
                            //Displaying the private question form field
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 15),
                              child: Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 450.0,
                                ),
                                child: TextFormField(
                                  controller: _privateQuestionController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 15,
                                  decoration: InputDecoration(
                                    hintText:
                                        'Enter your question. This conversation will be completely private between yourself and the counselor.',
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
                                      return "Please enter a question!";
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
                                //submit button
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
                                          if (_askPrivateQuestionformKey
                                              .currentState!
                                              .validate()) {
                                            submitPrivateQuestion(context);
                                          }
                                        },
                                        textColor: Colors.white,
                                        child: const Text(
                                          'Submit',
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

  Future<void> submitPrivateQuestion(BuildContext context) async {
    loadingDialog();

    if (context.mounted) {
      if (await checkLoginStatus(context)) {
        try {
          String? accessToken = await retrieveAccessToken();

          // Obtaining the URL to a variable
          String apiUrl = (await ReadApiEndpoints.readApiEndpointsData())["storePrivateQuestionEndpoint"];

          //Converting the url to uri
          Uri uri = Uri.parse(apiUrl);

          Map<String, dynamic> formData = {
            'private_question': _privateQuestionController.text,
            'admin': widget.adminId,
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
            print('Question Submitted successfully');
            if(context.mounted) {
              Navigator.of(context).pop();
              privateQuestionSubmittedDialogBox();
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

  void privateQuestionSubmittedDialogBox() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Question Sent To The Counselor',
        text: 'Please wait patiently until a reply is received.',
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
        barrierDismissible: false,
        disableBackBtn: true);
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
