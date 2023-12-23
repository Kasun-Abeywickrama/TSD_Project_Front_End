import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:tsd_project/decoration_tools/custom_loading_indicator.dart';
import 'package:tsd_project/important_tools/api_endpoints.dart';
import 'package:tsd_project/screen/login.dart';
import 'package:tsd_project/decoration_tools/top_app_bar.dart';
import 'package:tsd_project/important_tools/user_authentication.dart';

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
  void setQuizResultData(BuildContext context) async {
    if (context.mounted) {
      //Declaring the requested quiz result id
      final Map<String, dynamic> formData = {
        'quiz_result_id': widget.quizResultId,
      };

      //This process Fetches the data from the backend
      String? token = await secureStorage.read(key: 'token');
      if (token != null && Jwt.isExpired(token) == false) {
        try {
          // Obtaining the URL to a variable
          const String apiUrl = viewQuizResultEndpoint;

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

            if (context.mounted) {
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
            }
          } else {
            print('Failed to load data ${response.body}');
          }
        } catch (e) {
          print('Exception occured: $e');
        }
      } else {
        if (context.mounted) {
          Navigator.push(
              context, (MaterialPageRoute(builder: (context) => login_user())));
        }
      }
    }
  }

  //exceuting the setQuizResultData() when page begins (only the first time)
  @override
  void initState() {
    super.initState();
    initialProcess(context);
  }

  Future<void> initialProcess(BuildContext context) async {
    if (await checkLoginStatus(context)) {
      if (context.mounted) {
        setQuizResultData(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTopAppBar(
        pageIndex: 1,
        pageName: "Quiz Result",
      ),

      //If the page is still loading, display linear progress indicator, otherwise the content
      body: isLoading
          ? CustomLoadingIndicator()
          : Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: ListView(children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 40, 30, 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //First main container
                      Container(
                        constraints: const BoxConstraints(maxWidth: 768),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
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
                                  color: Color.fromARGB(255, 223, 222, 222),
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.all(20.0),
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
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontSize: 17,
                                                      color: Color.fromRGBO(
                                                          3, 71, 120, 1),
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
                                                      color: Color.fromRGBO(
                                                          3, 71, 120, 1),
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
                                  color: Color.fromARGB(255, 223, 222, 222),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
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
                                                    color: Color.fromRGBO(
                                                        3, 71, 120, 1),
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
                                                ":",
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: Color.fromRGBO(
                                                        3, 71, 120, 1),
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
                                                    color: Color.fromRGBO(
                                                        3, 71, 120, 1),
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
                                  color: Color.fromARGB(255, 223, 222, 222),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
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
                                                    color: Color.fromRGBO(
                                                        3, 71, 120, 1),
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
                                                ":",
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: Color.fromRGBO(
                                                        3, 71, 120, 1),
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
                                                    color: Color.fromRGBO(
                                                        3, 71, 120, 1),
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
                        height: 40.0,
                      ),
                      //Second main container
                      Container(
                        constraints: const BoxConstraints(maxWidth: 768),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
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
                                  color: Color.fromARGB(255, 223, 222, 222),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    children: [
                                      //Displaying the conclusion
                                      Row(children: [
                                        Expanded(
                                            child: Text(
                                          conclusion,
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromRGBO(
                                                  3, 71, 120, 1)),
                                        ))
                                      ]),
                                      const SizedBox(
                                        height: 15.0,
                                      ),
                                      //Displaying the counselor button
                                      if (counselorOrNot == 1)
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 20, 0, 0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Color(0xff2a58e5),
                                                    Color(0xff66bef4),
                                                  ],
                                                  stops: [0.25, 1],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                )),
                                            height: 45,
                                            constraints: const BoxConstraints(
                                              maxWidth: 450.0,
                                            ),
                                            child: MaterialButton(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                onPressed: () {},
                                                child: const Text(
                                                  'Request Professional Help',
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                          ),
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
              ]),
            ),
    );
  }
}
