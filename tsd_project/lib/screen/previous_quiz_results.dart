import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tsd_project/bottom_navigation_bar.dart';
import 'package:tsd_project/screen/home_screen.dart';
import 'package:tsd_project/screen/quiz_result_page.dart';
import 'package:tsd_project/top_app_bar.dart';
import 'package:tsd_project/user_authentication.dart';

class PreviousQuizResults extends StatefulWidget {
  @override
  State<PreviousQuizResults> createState() => _PreviousQuizResultsState();
}

class _PreviousQuizResultsState extends State<PreviousQuizResults> {
  //Declaring the variable to check if the page is still loading
  bool isLoading = true;

  //Initializing the flutter secure storage
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  //Initializing the list to store the data
  List<PreviousQuizResultsDataModel> previousQuizResultsList = [];

  //The function that requests the data list from the backend
  Future<void> setPreviousQuizResultData() async {
    await Future.delayed(const Duration(seconds: 1));

    //This process Fetches the data from the backend
    String? token = await secureStorage.read(key: 'token');
    if (token != null) {
      try {
        // Obtaining the URL to a variable
        final String apiUrl =
            'http://10.0.2.2:8000/view_previous_quiz_results/';

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

  //exceuting the setPreviousResultData() when page begins (only the first time)
  @override
  void initState() {
    super.initState();
    Future.microtask(() => checkLoginStatus(context));
    setPreviousQuizResultData();
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
        Navigator.push(
            context, (MaterialPageRoute(builder: (context) => HomeScreen())));
      },
      child: Scaffold(
          bottomNavigationBar: CustomBottomNavigationBar(
            initialIndex: 2,
          ),
          appBar: CustomTopAppBar(),
          body:
              //If the page is still loading, display linear progress indicator, otherwise the content
              isLoading
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
                  : (previousQuizResultsList.length == 0
                      ? Container(
                          color: const Color(0xE51FC0E7),
                          child: const Center(
                              child: Text(
                            "No Previous Results",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          )),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                              constraints: BoxConstraints(
                                maxWidth: screenWidth,
                              ),
                              decoration:
                                  const BoxDecoration(color: Color(0xE51FC0E7)),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                //A list.generate can only be used as a chilren of a column
                                child: CustomScrollView(slivers: [
                                  SliverFillRemaining(
                                    hasScrollBody: false,
                                    child: Column(
                                      children: List.generate(
                                        previousQuizResultsList.length,
                                        (i) => Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Container(
                                            constraints: const BoxConstraints(
                                                maxWidth: 768),
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15),
                                                bottomLeft: Radius.circular(15),
                                                bottomRight:
                                                    Radius.circular(15),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Color.fromRGBO(
                                                        92, 94, 95, 0.71),
                                                    offset: Offset(5, 5),
                                                    blurRadius: 4)
                                              ],
                                              color: Colors.white,
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
                                                                child: Text(
                                                              previousQuizResultsList[
                                                                      i]
                                                                  .date,
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 12),
                                                            )),
                                                            Expanded(
                                                                child: Text(
                                                                    previousQuizResultsList[
                                                                            i]
                                                                        .time,
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            12))),
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
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            12))),
                                                            Expanded(
                                                                child: Text(
                                                                    previousQuizResultsList[i]
                                                                            .score +
                                                                        "%",
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            12))),
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
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            12))),
                                                            Expanded(
                                                                child: Text(
                                                                    previousQuizResultsList[
                                                                            i]
                                                                        .dpLevel,
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            12))),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                              Flexible(
                                                flex: 2,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 12, 0),
                                                  child: ConstrainedBox(
                                                    constraints:
                                                        const BoxConstraints(
                                                            maxWidth: 75),
                                                    child: MaterialButton(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        color: const Color(
                                                            0xE51FC0E7),
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              (MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          QuizResultPage(
                                                                            quizResultId:
                                                                                previousQuizResultsList[i].quizResultId,
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
                                                              color:
                                                                  Colors.white,
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
                                  )
                                ]),
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
