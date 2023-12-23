import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:tsd_project/decoration_tools/bottom_navigation_bar.dart';
import 'package:tsd_project/decoration_tools/custom_loading_indicator.dart';
import 'package:tsd_project/important_tools/api_endpoints.dart';
import 'package:tsd_project/screen/home_screen.dart';
import 'package:tsd_project/screen/login.dart';
import 'package:tsd_project/screen/quiz_result_page.dart';
import 'package:tsd_project/decoration_tools/top_app_bar.dart';
import 'package:tsd_project/important_tools/user_authentication.dart';

class PreviousQuizResults extends StatefulWidget {
  @override
  State<PreviousQuizResults> createState() => _PreviousQuizResultsState();
}

class _PreviousQuizResultsState extends State<PreviousQuizResults> {
  //Declaring the variable to check if the page is still loading
  bool isLoading = true;

  bool latestDate = true;

  //Initializing the flutter secure storage
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  //Initializing the list to store the data
  List<PreviousQuizResultsDataModel> previousQuizResultsList = [];

  //The function that requests the data list from the backend
  Future<void> setPreviousQuizResultData(BuildContext context) async {
    print("refreshed");
    if (context.mounted) {
      //This process Fetches the data from the backend
      String? token = await secureStorage.read(key: 'token');
      if (token != null && Jwt.isExpired(token) == false) {
        try {
          // Obtaining the URL to a variable
          const String apiUrl = viewPreviousQuizResultsEndpoint;

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
            final previousQuizResults = json.decode(response.body);

            if (context.mounted) {
              //Intializing the list and rebuild the build method
              setState(() {
                //Initializing the list
                previousQuizResultsList =
                    List.from(previousQuizResults['previous_quiz_results'])
                        .map<PreviousQuizResultsDataModel>((item) {
                  return PreviousQuizResultsDataModel(
                      quizResultId: item['id'],
                      date: item['date'],
                      time: item['time'],
                      score: item['score'],
                      dpLevel: item['dp_level']);
                }).toList();

                previousQuizResultsList =
                    List.from(previousQuizResultsList.reversed);

                //Considering the page is loaded
                isLoading = false;

                latestDate = true;
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

  //exceuting the setPreviousResultData() when page begins (only the first time)
  @override
  void initState() {
    super.initState();
    initialProcess(context);
  }

  Future<void> initialProcess(BuildContext context) async {
    if (await checkLoginStatus(context)) {
      if (context.mounted) {
        setPreviousQuizResultData(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 300) {
      screenWidth = 300;
    }
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        Navigator.push(context,
            (MaterialPageRoute(builder: (context) => const HomeScreen())));
      },
      child: Scaffold(
          bottomNavigationBar: CustomBottomNavigationBar(
            initialIndex: 2,
          ),
          appBar: CustomTopAppBar(
            pageName: "Previous Results",
            pageIndex: 0,
          ),
          body:
              //If the page is still loading, display linear progress indicator, otherwise the content
              isLoading
                  ? CustomLoadingIndicator()
                  : (previousQuizResultsList.isEmpty
                      ? Container(
                          color: Colors.white,
                          child: const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Center(
                                child: Text(
                              "< No Previous Results >",
                              style: TextStyle(
                                  color: Color.fromRGBO(3, 71, 120, 1),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                              constraints: BoxConstraints(
                                maxWidth: screenWidth,
                              ),
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                //A list.generate can only be used as a chilren of a column
                                child: RefreshIndicator(
                                  onRefresh: () => initialProcess(context),
                                  child: ListView(children: [
                                    Center(
                                      child: Container(
                                        constraints:
                                            const BoxConstraints(maxWidth: 768),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Row(
                                                children: [
                                                  latestDate == true
                                                      ? Container(
                                                          constraints:
                                                              const BoxConstraints(
                                                                  maxHeight:
                                                                      40),
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                  gradient:
                                                                      const LinearGradient(
                                                                    colors: [
                                                                      Color(
                                                                          0xff66bef4),
                                                                      Color(
                                                                          0xff2a58e5)
                                                                    ],
                                                                    stops: [
                                                                      0.25,
                                                                      0.6
                                                                    ],
                                                                    begin: Alignment
                                                                        .topLeft,
                                                                    end: Alignment
                                                                        .bottomRight,
                                                                  )),
                                                          child: MaterialButton(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15)),
                                                              onPressed: () {},
                                                              child: const Text(
                                                                "Latest",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              )),
                                                        )
                                                      : Container(
                                                          constraints:
                                                              const BoxConstraints(
                                                                  maxHeight:
                                                                      40),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color
                                                                .fromARGB(255,
                                                                212, 211, 211),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                          child: MaterialButton(
                                                              onPressed: () {
                                                                if (context
                                                                    .mounted) {
                                                                  setState(() {
                                                                    previousQuizResultsList =
                                                                        List.from(
                                                                            previousQuizResultsList.reversed);
                                                                    latestDate =
                                                                        true;
                                                                  });
                                                                }
                                                              },
                                                              child: const Text(
                                                                "Latest",
                                                                style: TextStyle(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            3,
                                                                            71,
                                                                            120,
                                                                            1),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )),
                                                        ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  latestDate == false
                                                      ? Container(
                                                          constraints:
                                                              const BoxConstraints(
                                                                  maxHeight:
                                                                      40),
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                  gradient:
                                                                      const LinearGradient(
                                                                    colors: [
                                                                      Color(
                                                                          0xff66bef4),
                                                                      Color(
                                                                          0xff2a58e5)
                                                                    ],
                                                                    stops: [
                                                                      0.25,
                                                                      0.6
                                                                    ],
                                                                    begin: Alignment
                                                                        .topLeft,
                                                                    end: Alignment
                                                                        .bottomRight,
                                                                  )),
                                                          child: MaterialButton(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15)),
                                                              onPressed: () {},
                                                              child: const Text(
                                                                  "Oldest",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold))),
                                                        )
                                                      : Container(
                                                          constraints:
                                                              const BoxConstraints(
                                                                  maxHeight:
                                                                      40),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color
                                                                .fromARGB(255,
                                                                212, 211, 211),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                          child: MaterialButton(
                                                              onPressed: () {
                                                                if (context
                                                                    .mounted) {
                                                                  setState(() {
                                                                    previousQuizResultsList =
                                                                        List.from(
                                                                            previousQuizResultsList.reversed);
                                                                    latestDate =
                                                                        false;
                                                                  });
                                                                }
                                                              },
                                                              child: const Text(
                                                                "Oldest",
                                                                style: TextStyle(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            3,
                                                                            71,
                                                                            120,
                                                                            1),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )),
                                                        ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              children: List.generate(
                                                previousQuizResultsList.length,
                                                (i) => Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 232, 230, 230),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(15),
                                                        topRight:
                                                            Radius.circular(15),
                                                        bottomLeft:
                                                            Radius.circular(15),
                                                        bottomRight:
                                                            Radius.circular(15),
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color:
                                                                Color.fromRGBO(
                                                                    92,
                                                                    94,
                                                                    95,
                                                                    0.71),
                                                            offset:
                                                                Offset(5, 2),
                                                            blurRadius: 4)
                                                      ],
                                                    ),
                                                    child: Row(children: [
                                                      Expanded(
                                                          flex: 8,
                                                          child: Column(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        20.0,
                                                                        10.0,
                                                                        20.0,
                                                                        5.0),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                        child:
                                                                            Text(
                                                                      previousQuizResultsList[
                                                                              i]
                                                                          .date,
                                                                      style:
                                                                          const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: Color.fromRGBO(
                                                                            3,
                                                                            71,
                                                                            120,
                                                                            1),
                                                                        fontSize:
                                                                            13,
                                                                      ),
                                                                    )),
                                                                    Expanded(
                                                                        child: Text(
                                                                            previousQuizResultsList[i]
                                                                                .time,
                                                                            style: const TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Color.fromRGBO(3, 71, 120, 1),
                                                                                fontSize: 13))),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        20.0,
                                                                        10.0,
                                                                        20.0,
                                                                        5.0),
                                                                child: Row(
                                                                  children: [
                                                                    const Expanded(
                                                                        child: Text(
                                                                            "Score : ",
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Color.fromRGBO(3, 71, 120, 1),
                                                                                fontSize: 13))),
                                                                    Expanded(
                                                                        child: Text(
                                                                            "${previousQuizResultsList[i].score}%",
                                                                            style: const TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Color.fromRGBO(3, 71, 120, 1),
                                                                                fontSize: 13))),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        20.0,
                                                                        10.0,
                                                                        20.0,
                                                                        10.0),
                                                                child: Row(
                                                                  children: [
                                                                    const Expanded(
                                                                        child: Text(
                                                                            "DP Level : ",
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Color.fromRGBO(3, 71, 120, 1),
                                                                                fontSize: 13))),
                                                                    Expanded(
                                                                        child: Text(
                                                                            previousQuizResultsList[i]
                                                                                .dpLevel,
                                                                            style: const TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Color.fromRGBO(3, 71, 120, 1),
                                                                                fontSize: 13))),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          )),
                                                      Flexible(
                                                        flex: 2,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  0, 0, 12, 0),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                    gradient:
                                                                        const LinearGradient(
                                                                      colors: [
                                                                        Color(
                                                                            0xff66bef4),
                                                                        Color(
                                                                            0xff2a58e5)
                                                                      ],
                                                                      stops: [
                                                                        0.25,
                                                                        0.6
                                                                      ],
                                                                      begin: Alignment
                                                                          .topLeft,
                                                                      end: Alignment
                                                                          .bottomRight,
                                                                    )),
                                                            constraints:
                                                                const BoxConstraints(
                                                                    maxWidth:
                                                                        75,
                                                                    maxHeight:
                                                                        35),
                                                            child: MaterialButton(
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.0),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      (MaterialPageRoute(
                                                                          builder: (context) => QuizResultPage(
                                                                                quizResultId: previousQuizResultsList[i].quizResultId,
                                                                              ))));
                                                                },
                                                                child: const Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .double_arrow,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 20,
                                                                    ),
                                                                  ],
                                                                )),
                                                          ),
                                                        ),
                                                      ),
                                                    ]),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ]),
                                ),
                              )),
                        ))),
    );
  }
}

//Creating the class to store the previous results data
class PreviousQuizResultsDataModel {
  int quizResultId;
  String date;
  String time;
  String score;
  String dpLevel;

  PreviousQuizResultsDataModel(
      {required this.quizResultId,
      required this.date,
      required this.time,
      required this.dpLevel,
      required this.score});
}
