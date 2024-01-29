import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:tsd_project/decoration_tools/custom_loading_indicator.dart';
import 'package:tsd_project/important_tools/api_endpoints.dart';
import 'package:tsd_project/important_tools/user_authentication.dart';
import 'package:tsd_project/pages/my_account/edit_personal_details_page.dart';
import 'package:tsd_project/pages/private_guidance/ask_private_question_counselor_list_page.dart';
import 'package:tsd_project/pages/private_guidance/display_private_question_page.dart';
import '../../decoration_tools/top_app_bar.dart';

class RequestGuidancePage extends StatefulWidget {
  @override
  State<RequestGuidancePage> createState() => _RequestGuidancePageState();
}

class _RequestGuidancePageState extends State<RequestGuidancePage> {
  //Declaring the variable to check if the page is still loading
  bool isLoading = true;

  bool latestDate = true;

  //Initializing the list to store the data
  List<PrivateQuestionsAndAnswersDataModel> privateQuestionsAndAnswersList = [];

  //The function that requests the data list from the backend
  Future<void> setPrivateQuestionsAndAnswersData(BuildContext context) async {
    print("refreshed");

    //This process Fetches the data from the backend

    if (context.mounted) {
      if (await checkLoginStatus(context)) {
        try {
          String? accessToken = await retrieveAccessToken();

          // Obtaining the URL to a variable
          const String apiUrl = requestPrivateQuestionsEndpoint;

          //Converting the url to uri
          Uri uri = Uri.parse(apiUrl);

          //Requesting the data from the backend
          final response = await http.get(
            uri,
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            },
          );

          if (response.statusCode == 200) {
            //Decode the response
            final privateQuestionsAndAnswers = json.decode(response.body);

            if (context.mounted) {
              //Intializing the list and rebuild the build method
              setState(() {
                //Initializing the list
                privateQuestionsAndAnswersList = List.from(
                        privateQuestionsAndAnswers[
                            'private_questions_and_answers'])
                    .map<PrivateQuestionsAndAnswersDataModel>((item) {
                  return PrivateQuestionsAndAnswersDataModel(
                    privateQuestionId: item['private_question_id'],
                    privateQuestion: item['private_question'],
                    privateAnswer: item['private_answer'],
                    askedDate: item['asked_date'],
                    askedTime: item['asked_time'],
                    counselorFirstName: item['counselor_first_name'],
                    counselorLastName: item['counselor_last_name'],
                  );
                }).toList();

                privateQuestionsAndAnswersList =
                    List.from(privateQuestionsAndAnswersList.reversed);

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
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initialProcess(context);
  }

  Future<void> initialProcess(BuildContext context) async {
    if (await checkLoginStatus(context)) {
      if (context.mounted) {
        setPrivateQuestionsAndAnswersData(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 300) {
      screenWidth = 300;
    }
    return Scaffold(
        appBar: CustomTopAppBar(
          pageIndex: 1,
          pageName: "Request Guidance",
        ),
        body: isLoading
            ? CustomLoadingIndicator()
            : (privateQuestionsAndAnswersList.isEmpty
                ? Container(
                    color: Colors.white,
                    child: RefreshIndicator(
                      onRefresh: () => initialProcess(context),
                      child: CustomScrollView(slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(15.0, 40, 15, 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
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
                                                BorderRadius.circular(10.0),
                                          ),
                                          onPressed: () {
                                            redirectToCounselorList(context);
                                          },
                                          child: const Text(
                                            'Ask A Question ?',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ))
                : Container(
                    color: Colors.white,
                    //List View
                    child: RefreshIndicator(
                        onRefresh: () => initialProcess(context),
                        child: ListView(
                          children: [
                            SingleChildScrollView(
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
                                    child: Center(
                                      child: Container(
                                        constraints:
                                            const BoxConstraints(maxWidth: 768),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      15.0, 15, 15, 30),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    gradient:
                                                        const LinearGradient(
                                                      colors: [
                                                        Color(0xff2a58e5),
                                                        Color(0xff66bef4),
                                                      ],
                                                      stops: [0.25, 1],
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                    )),
                                                height: 45,
                                                constraints:
                                                    const BoxConstraints(
                                                  maxWidth: 450.0,
                                                ),
                                                child: MaterialButton(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    onPressed: () {
                                                      redirectToCounselorList(
                                                          context);
                                                    },
                                                    child: const Text(
                                                      'Ask A Question ?',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                              ),
                                            ),
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
                                                                    privateQuestionsAndAnswersList =
                                                                        List.from(
                                                                            privateQuestionsAndAnswersList.reversed);
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
                                                                    privateQuestionsAndAnswersList =
                                                                        List.from(
                                                                            privateQuestionsAndAnswersList.reversed);
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
                                                privateQuestionsAndAnswersList
                                                    .length,
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
                                                                    const Expanded(
                                                                        flex: 4,
                                                                        child: Text(
                                                                            "Counselor : ",
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Color.fromRGBO(3, 71, 120, 1),
                                                                                fontSize: 16))),
                                                                    Expanded(
                                                                        flex: 6,
                                                                        child: Text(
                                                                            "${privateQuestionsAndAnswersList[i].counselorFirstName} ${privateQuestionsAndAnswersList[i].counselorLastName}",
                                                                            style: const TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Color.fromRGBO(3, 71, 120, 1),
                                                                                fontSize: 16))),
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
                                                                        flex: 2,
                                                                        child: Text(
                                                                            "Q : ",
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Color.fromRGBO(3, 71, 120, 1),
                                                                                fontSize: 16))),
                                                                    Expanded(
                                                                        flex: 8,
                                                                        child: Text(
                                                                            (privateQuestionsAndAnswersList[i].privateQuestion.length <= 50)
                                                                                ? privateQuestionsAndAnswersList[i].privateQuestion
                                                                                : '${privateQuestionsAndAnswersList[i].privateQuestion.substring(0, 50)}...',
                                                                            style: const TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(3, 71, 120, 1), fontSize: 13))),
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
                                                                        flex: 2,
                                                                        child: Text(
                                                                            "A : ",
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Color.fromRGBO(3, 71, 120, 1),
                                                                                fontSize: 16))),
                                                                    Expanded(
                                                                        flex: 8,
                                                                        child: Text(
                                                                            (privateQuestionsAndAnswersList[i].privateAnswer.length <= 50)
                                                                                ? privateQuestionsAndAnswersList[i].privateAnswer
                                                                                : '${privateQuestionsAndAnswersList[i].privateAnswer.substring(0, 50)}...',
                                                                            style: const TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(3, 71, 120, 1), fontSize: 13))),
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
                                                            child:
                                                                MaterialButton(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.0),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      //Redirect to display private question page
                                                                      Map<String,
                                                                              dynamic>
                                                                          privateQuestionDetails =
                                                                          {
                                                                        'private_question':
                                                                            privateQuestionsAndAnswersList[i].privateQuestion,
                                                                        'private_answer':
                                                                            privateQuestionsAndAnswersList[i].privateAnswer,
                                                                        'asked_date':
                                                                            privateQuestionsAndAnswersList[i].askedDate,
                                                                        'asked_time':
                                                                            privateQuestionsAndAnswersList[i].askedTime,
                                                                        'counselor_first_name':
                                                                            privateQuestionsAndAnswersList[i].counselorFirstName,
                                                                        'counselor_last_name':
                                                                            privateQuestionsAndAnswersList[i].counselorLastName,
                                                                      };
                                                                      Navigator.push(
                                                                          context,
                                                                          (MaterialPageRoute(
                                                                              builder: (context) => DisplayPrivateQuestionPage(
                                                                                    privateQuestionDetails: privateQuestionDetails,
                                                                                  ))));
                                                                    },
                                                                    child:
                                                                        const Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .double_arrow,
                                                                          color:
                                                                              Colors.white,
                                                                          size:
                                                                              20,
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
                                    ),
                                  )),
                            ),
                          ],
                        )),
                  )));
  }

  Future<void> redirectToCounselorList(BuildContext context) async {
    if (await allPersonalDetailsFilled(context)) {
      if (context.mounted) {
        Navigator.of(context).pop();
        Navigator.push(
            context,
            (MaterialPageRoute(
                builder: (context) => AskPrivateQuestionCounselorListPage())));
      }
    } else {
      if(context.mounted) {
        Navigator.of(context).pop();
        fillPersonalDetailsDialog();
      }
    }
  }

  //Info dialog box to tell the patient to fill the personal details
  void fillPersonalDetailsDialog() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        title: 'The Personal Details are Required',
        text: 'Please fill your personal details before requesting guidance.',
        onConfirmBtnTap: () {
          Navigator.pushReplacement(
              context,
              (MaterialPageRoute(
                  builder: (context) => EditPersonalDetailsPage())));
        });
  }

  //Function that gets the user personal details from the database and check all of them are filled
  Future<bool> allPersonalDetailsFilled(BuildContext context) async {
    loadingDialog();
    //This process Fetches the data from the backend

    if (context.mounted) {
      if (await checkLoginStatus(context)) {
        try {
          String? accessToken = await retrieveAccessToken();

          // Obtaining the URL to a variable
          const String apiUrl = requestPatientPersonalDetailsEndpoint;

          //Converting the url to uri
          Uri uri = Uri.parse(apiUrl);

          //Requesting the data from the backend
          final response = await http.get(
            uri,
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            },
          );

          if (response.statusCode == 200) {
            //Decode the response
            final Map<String, dynamic> backendUserDetails =
                json.decode(response.body);

            if ((backendUserDetails['patient_personal_details']['first_name'] !=
                    null) &&
                (backendUserDetails['patient_personal_details']
                        ['last_name'] !=
                    null) &&
                (backendUserDetails['patient_personal_details']
                        ['mobile_number'] !=
                    null) &&
                (backendUserDetails['patient_personal_details']
                        ['date_of_birth'] !=
                    null)) {
              return true;
            }
          } else {
            print('Failed to receive data ${response.body}');
          }
        } catch (e) {
          print('Exception occured: $e');
        }
      }
    }
    return false;
  }

  //Creating the alert dialog box to display loading
  void loadingDialog() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
        barrierDismissible: false,
        disableBackBtn: true,
        title: 'Loading',
        text: 'Please wait patiently!');
  }
}

//Creating the class to store the previous results data
class PrivateQuestionsAndAnswersDataModel {
  int privateQuestionId;
  String privateQuestion;
  String privateAnswer;
  String askedDate;
  String askedTime;
  String counselorFirstName;
  String counselorLastName;

  PrivateQuestionsAndAnswersDataModel(
      {required this.privateQuestionId,
      required this.privateQuestion,
      required this.askedDate,
      required this.askedTime,
      required this.counselorFirstName,
      required this.counselorLastName,
      required this.privateAnswer});
}
