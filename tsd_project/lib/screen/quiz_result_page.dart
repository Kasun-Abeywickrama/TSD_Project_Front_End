import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tsd_project/bottom_navigation_bar.dart';
import 'package:tsd_project/top_app_bar.dart';
import 'package:tsd_project/user_authentication.dart';

class QuizResultPage extends StatefulWidget {
  //Declaring the quiz result id that must be received when navigating
  final int quizResultId;

  //Declaring the Constructor for the quiz result id
  const QuizResultPage({required this.quizResultId});

  @override
  State<QuizResultPage> createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage> {
  //Declaring the variable to check if the page is still loading
  bool isLoading = true;

  //Declaring varaibles to store the quiz result data, these will be displayed in this page
  String date = '';
  String time = '';
  double score = 0.0;
  String dpLevel = '';
  String conclusion = '';
  int counselorOrNot = 0;

  //Initializing the flutter secure storage
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  //Creating the function that sets the relavant fields
  void setQuizResultData() async {
    await Future.delayed(const Duration(seconds: 1));

    //Declaring the requested quiz result id
    final Map<String, dynamic> formData = {
      'quiz_result_id': widget.quizResultId,
    };

    //This process Fetches the data from the backend
    String? token = await secureStorage.read(key: 'token');
    if (token != null) {
      try {
        // Obtaining the URL to a variable
        final String apiUrl = 'http://10.0.2.2:8000/view_quiz_result/';

        //Converting the url to uri
        Uri uri = Uri.parse(apiUrl);

        //Requesting the data from the backend
        final response = await http.post(
          uri,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: json.encode(formData),
        );

        if (response.statusCode == 200) {
          //Decode the response
          final Map<String, dynamic> backendQuizResultMap =
              json.decode(response.body);
          //Intializing these variables and rebuild the build method
          setState(() {
            date = backendQuizResultMap['date'];
            time = backendQuizResultMap['time'];
            score = double.parse(backendQuizResultMap['score']);
            dpLevel = backendQuizResultMap['dp_level'];
            conclusion = backendQuizResultMap['conclusion'];
            counselorOrNot =
                int.parse(backendQuizResultMap['counselor_or_not']);
            //Considering the page is loaded
            isLoading = false;
          });
        } else {
          print('Failed to load data ${response.body}');
        }
      } catch (e) {
        print('Exception occured: $e');
      }
    } else {
      print('Token is null');
    }
  }

  //exceuting the setQuizResultData() when page begins (only the first time)
  @override
  void initState() {
    super.initState();
    Future.microtask(() => checkLoginStatus(context));
    setQuizResultData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CustomBottomNavigationBar(
          initialIndex: -1,
        ),
        appBar: CustomTopAppBar(),

        //If the page is still loading, display linear progress indicator, otherwise the content
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
                decoration: const BoxDecoration(color: Color(0xE51FC0E7)),
                child: CustomScrollView(slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //First main container
                          Container(
                            constraints: const BoxConstraints(maxWidth: 768),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(92, 94, 95, 0.71),
                                    offset: Offset(5, 5),
                                    blurRadius: 4)
                              ],
                              color: Color.fromARGB(255, 38, 75, 205),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  //Date Container
                                  Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Color.fromRGBO(0, 0, 0, 0.25),
                                            offset: Offset(5, 5),
                                            blurRadius: 4)
                                      ],
                                      color: Color.fromRGBO(
                                          255, 255, 255, 0.8899999856948853),
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        //If the date is not null, display the relavant backend data
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                flex: 5,
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      date,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      time,
                                                      style: const TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ])),
                                  ),
                                  const SizedBox(
                                    height: 18.0,
                                  ),
                                  //Score Container
                                  Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Color.fromRGBO(0, 0, 0, 0.25),
                                            offset: Offset(5, 5),
                                            blurRadius: 4)
                                      ],
                                      color: Color.fromRGBO(
                                          255, 255, 255, 0.8899999856948853),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Expanded(
                                              flex: 3,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "Score",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Expanded(
                                              flex: 3,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "-",
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    '$score%',
                                                    style: const TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 18.0,
                                  ),
                                  //Depression Level Container
                                  Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Color.fromRGBO(0, 0, 0, 0.25),
                                            offset: Offset(5, 5),
                                            blurRadius: 4)
                                      ],
                                      color: Color.fromRGBO(
                                          255, 255, 255, 0.8899999856948853),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Expanded(
                                              flex: 4,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "Depression Level",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Expanded(
                                              flex: 1,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "-",
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 5,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    dpLevel,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 22.0,
                          ),
                          //Second main container
                          Container(
                            constraints: const BoxConstraints(maxWidth: 768),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(92, 94, 95, 0.71),
                                    offset: Offset(5, 5),
                                    blurRadius: 4)
                              ],
                              color: Color.fromARGB(255, 38, 75, 205),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  //Conclusion Container
                                  Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Color.fromRGBO(0, 0, 0, 0.25),
                                            offset: Offset(5, 5),
                                            blurRadius: 4)
                                      ],
                                      color: Color.fromRGBO(
                                          255, 255, 255, 0.8899999856948853),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        children: [
                                          //Displaying the conclusion
                                          Row(children: [
                                            Expanded(
                                                child: Text(
                                              conclusion,
                                              style:
                                                  const TextStyle(fontSize: 17),
                                            ))
                                          ]),
                                          const SizedBox(
                                            height: 20.0,
                                          ),
                                          //Displaying the counselor button
                                          if (counselorOrNot == 1)
                                            Container(
                                              height: 45,
                                              constraints: const BoxConstraints(
                                                maxWidth: 450.0,
                                              ),
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: const Color
                                                        .fromRGBO(0, 57, 255,
                                                        0.8), // Background color
                                                    foregroundColor: Colors
                                                        .white, // Text color
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0), // Border radius
                                                      side: const BorderSide(
                                                          color: Color.fromRGBO(
                                                              0,
                                                              57,
                                                              255,
                                                              0.8)), // Border color
                                                    ),
                                                  ),
                                                  onPressed: () {},
                                                  child: const Text(
                                                    'Request Professional Help',
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                            )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ));
  }
}
