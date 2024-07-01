import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:tsd_project/decoration_tools/custom_loading_indicator.dart';
import 'package:tsd_project/important_tools/api_endpoints.dart';
import 'package:tsd_project/important_tools/result_calculation.dart';
import 'package:tsd_project/pages/quiz/quiz_result_page.dart';
import 'package:tsd_project/decoration_tools/top_app_bar.dart';
import 'package:tsd_project/important_tools/user_authentication.dart';

class QuizPage extends StatefulWidget {
  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  //Declaring the variable to check if the page is loading
  bool isLoading = true;

  //This is the list that stores the quiz
  List<QuizModel> receivedQuiz = [];

  //Creating a page Controller
  PageController questionPageController = PageController(initialPage: 0);

  //Adjusting the answer button color
  int? selectedAnswerIndex;

  //Creating a text controller to get the no.of days
  TextEditingController dayController = TextEditingController();

  //Creating a global form key to validate the day input form
  final GlobalKey<FormState> _dayformKey = GlobalKey<FormState>();

  //Creating the list to store the answers of the user (question id, answer id, mark)
  List<QuizResultModel> qandAData = [];

  //These two functions are used to check whether the user logged in
  //This function will call the checkLoginState() and requestQuiz() functions at the beggining of the page
  @override
  void initState() {
    super.initState();
    initialProcess(context);
  }

  Future<void> initialProcess(BuildContext context) async {
    if (await checkLoginStatus(context)) {
      if (context.mounted) {
        requestQuiz(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 270) {
      screenWidth = 270;
    }
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        quitOptionDialog();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,

        appBar: CustomTopAppBar(
          pageIndex: 2,
          pageName: "Quiz",
        ),
        //Creating a pageview
        body:
            // If the page is still loading, display an indicator, otherwise, display the content
            isLoading
                ? CustomLoadingIndicator()
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: screenWidth,
                      ),
                      decoration: const BoxDecoration(color: Colors.white),
                      child: PageView.builder(
                        //Assigning the questionPageController as the controller
                        controller: questionPageController,
                        //The no.of questions must be stored in itemcount (including the day question)
                        itemCount: receivedQuiz.length + 1,
                        //The page content is stored in the itemBuilder
                        itemBuilder: (context, index) {
                          //Dividing the page into columns
                          //A column is created and surrounded by a padding widget
                          //The single child scroll view does not work with expanded wideget
                          //Therefore I used a Custom scroll view to make the content scrollable
                          return CustomScrollView(slivers: [
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(30.0, 0, 30, 30),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      //Displaying the question number and the quit button
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          //Displaying the question number
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                30, 0, 0, 0),
                                            child: SizedBox(
                                                width: 100,
                                                height: 160,
                                                child: Stack(children: [
                                                  Positioned(
                                                      top: 50,
                                                      left: 2,
                                                      child: Transform.rotate(
                                                        angle: 45 * (pi / 180),
                                                        child: Container(
                                                            width: 60,
                                                            height: 60,
                                                            decoration:
                                                                const BoxDecoration(
                                                                    boxShadow: [
                                                                  BoxShadow(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              0.5),
                                                                      offset:
                                                                          Offset(
                                                                              4,
                                                                              4),
                                                                      blurRadius:
                                                                          4)
                                                                ],
                                                                    gradient:
                                                                        LinearGradient(
                                                                      colors: [
                                                                        Color(
                                                                            0xff2a58e5),
                                                                        Color(
                                                                            0xff66bef4),
                                                                      ],
                                                                      stops: [
                                                                        0.25,
                                                                        0.9
                                                                      ],
                                                                      begin: Alignment
                                                                          .centerLeft,
                                                                      end: Alignment
                                                                          .centerRight,
                                                                    ))),
                                                      )),
                                                  Positioned(
                                                      top: 60,
                                                      left: 0,
                                                      child: Transform.rotate(
                                                        angle: 45 * (pi / 180),
                                                        child: Container(
                                                            width: 60,
                                                            height: 60,
                                                            decoration:
                                                                const BoxDecoration(
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color:
                                                                        Color.fromRGBO(
                                                                            0,
                                                                            0,
                                                                            0,
                                                                            0.5),
                                                                    offset:
                                                                        Offset(
                                                                            4,
                                                                            4),
                                                                    blurRadius:
                                                                        4)
                                                              ],
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      246,
                                                                      241,
                                                                      241),
                                                            )),
                                                      )),
                                                  Positioned(
                                                      top: 73,
                                                      left: 8,
                                                      child: GradientText(
                                                        '${(index + 1) < 10 ? '0${index + 1}' : index + 1}',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                'ArchivoBlack',
                                                            fontSize: 35,
                                                            letterSpacing: 0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            height: 1),
                                                        colors: const [
                                                          Color(0xff2a58e5),
                                                          Color.fromARGB(255,
                                                              47, 153, 219),
                                                          Color(0xff2a58e5),
                                                        ],
                                                      )),
                                                ])),
                                          ),
                                        ],
                                      ),

                                      //Displaying the question
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Color(0xff66bef4),
                                                      Color(0xff2a58e5),
                                                    ],
                                                    stops: [0.05, 0.45],
                                                    begin: Alignment.centerLeft,
                                                    end: Alignment.centerRight,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(75),
                                                    topRight:
                                                        Radius.circular(75),
                                                    bottomLeft:
                                                        Radius.circular(75),
                                                    bottomRight:
                                                        Radius.circular(75),
                                                  )),
                                              child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  //if it is not the last page, display normal questions. Otherwise, display day question
                                                  child: index !=
                                                          receivedQuiz.length
                                                      ? Text(
                                                          receivedQuiz[index]
                                                              .question,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontFamily:
                                                                      'Archivo',
                                                                  fontSize: 20,
                                                                  letterSpacing:
                                                                      0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  height: 1),
                                                        )
                                                      : const Text(
                                                          'For how many days did you encounter these issues ?',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'Archivo',
                                                              fontSize: 20,
                                                              letterSpacing: 0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              height: 1),
                                                        )),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(
                                        height: 25.0,
                                      ),

                                      //Displaying answer buttons or the text form field
                                      index != receivedQuiz.length
                                          ? SizedBox(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                //This is an another way to generate the same result as a for loop (List.generate method)
                                                children: List.generate(
                                                  receivedQuiz[index]
                                                      .answers
                                                      .length,
                                                  (i) => Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 10, 0, 10),
                                                    child: Container(
                                                      decoration:
                                                          selectedAnswerIndex ==
                                                                  i
                                                              ? BoxDecoration(
                                                                  boxShadow: const [
                                                                    BoxShadow(
                                                                        color: Color.fromRGBO(
                                                                            128,
                                                                            128,
                                                                            129,
                                                                            0.71),
                                                                        offset: Offset(
                                                                            5,
                                                                            2),
                                                                        blurRadius:
                                                                            4)
                                                                  ],
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              75),
                                                                  gradient:
                                                                      const LinearGradient(
                                                                    colors: [
                                                                      Color(
                                                                          0xff2a58e5),
                                                                      Color(
                                                                          0xff66bef4),
                                                                    ],
                                                                    stops: [
                                                                      0.25,
                                                                      0.9
                                                                    ],
                                                                    begin: Alignment
                                                                        .centerLeft,
                                                                    end: Alignment
                                                                        .centerRight,
                                                                  ),
                                                                )
                                                              : BoxDecoration(
                                                                  boxShadow: const [
                                                                    BoxShadow(
                                                                        color: Color.fromRGBO(
                                                                            128,
                                                                            128,
                                                                            129,
                                                                            0.71),
                                                                        offset: Offset(
                                                                            5,
                                                                            2),
                                                                        blurRadius:
                                                                            4)
                                                                  ],
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              75),
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      232,
                                                                      230,
                                                                      230),
                                                                ),
                                                      child: MaterialButton(
                                                        height: 45,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(75),
                                                        ),
                                                        onPressed: () {
                                                          //When setState function is executed the build widget will run again. This time it will run with selectedAnswerIndex = i
                                                          setState(() {
                                                            selectedAnswerIndex =
                                                                i;
                                                          });
                                                        },
                                                        child: Row(
                                                          children: [
                                                            //Displaying the circle shape in front of the answer in the button
                                                            Container(
                                                                width: 15,
                                                                height: 15,
                                                                decoration:
                                                                    selectedAnswerIndex ==
                                                                            i
                                                                        ? const BoxDecoration(
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                232,
                                                                                230,
                                                                                230),
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.elliptical(15, 15)),
                                                                          )
                                                                        : const BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.elliptical(15, 15)),
                                                                            gradient:
                                                                                LinearGradient(
                                                                              colors: [
                                                                                Color(0xff66bef4),
                                                                                Color(0xff2a58e5),
                                                                              ],
                                                                              stops: [
                                                                                0.05,
                                                                                0.45
                                                                              ],
                                                                              begin: Alignment.centerLeft,
                                                                              end: Alignment.centerRight,
                                                                            ),
                                                                          )),
                                                            const SizedBox(
                                                              width: 10.0,
                                                            ),
                                                            //Displaying the answer inside the button
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        15.0),
                                                                child: Text(
                                                                  //The answers of the related question is stored in a map, this will get all the keys of the map and will put them into a list. Then get the related indexed one.
                                                                  receivedQuiz[
                                                                          index]
                                                                      .answers[
                                                                          i]
                                                                      .answer,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      color: selectedAnswerIndex == i
                                                                          ? Colors
                                                                              .white
                                                                          : const Color
                                                                              .fromRGBO(
                                                                              3,
                                                                              71,
                                                                              120,
                                                                              1),
                                                                      fontSize:
                                                                          20,
                                                                      letterSpacing:
                                                                          0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      height:
                                                                          1),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      30, 30, 30, 10),
                                              child: Form(
                                                  key: _dayformKey,
                                                  child: Container(
                                                    constraints:
                                                        const BoxConstraints(
                                                      maxWidth: 300.0,
                                                    ),
                                                    child: TextFormField(
                                                      controller: dayController,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: 'No.Of Days',
                                                        prefixIcon: const Icon(
                                                            Icons.date_range),
                                                        filled: true,
                                                        fillColor: const Color
                                                            .fromARGB(
                                                            255, 232, 230, 230),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30.0),
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          232,
                                                                          230,
                                                                          230)),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30.0),
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          232,
                                                                          230,
                                                                          230)),
                                                        ),
                                                        errorBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30.0),
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .red,
                                                                  width: 2),
                                                        ),
                                                        focusedErrorBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30.0),
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .red,
                                                                  width: 2),
                                                        ),
                                                      ),
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return "Enter No.Of Days";
                                                        } else {
                                                          return null;
                                                        }
                                                      },
                                                    ),
                                                  )),
                                            ),

                                      const SizedBox(
                                        height: 30.0,
                                      ),

                                      //Creating the next and previous buttons
                                      //I make these two buttons expanded, then they will take all the available space
                                      //After that, i make them aligned in the bottom
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              //Creating the Previous button
                                              Container(
                                                decoration: const BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color(0xff66bef4),
                                                        Color(0xff2a58e5)
                                                      ],
                                                      stops: [0.1, 0.6],
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                    ),
                                                    shape: BoxShape.circle),
                                                child: MaterialButton(
                                                    shape: const CircleBorder(),
                                                    onPressed: () {
                                                      if (index == 0) {
                                                        quitOptionDialog();
                                                      } else {
                                                        //First the selected index will be assigned to null, because then it will not display any selected options
                                                        selectedAnswerIndex =
                                                            null;

                                                        if (qandAData
                                                            .isNotEmpty) {
                                                          qandAData
                                                              .removeLast();
                                                        }

                                                        questionPageController
                                                            .previousPage(
                                                                duration:
                                                                    const Duration(
                                                                        milliseconds:
                                                                            500),
                                                                curve: Curves
                                                                    .ease);
                                                      }
                                                    },
                                                    child: const Icon(
                                                      Icons.arrow_back,
                                                      color: Colors.white,
                                                      size: 40,
                                                    )),
                                              ),

                                              //If it is not the last page, then display next button. Otherwise, display submit button
                                              index != receivedQuiz.length
                                                  ? Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                              gradient:
                                                                  LinearGradient(
                                                                colors: [
                                                                  Color(
                                                                      0xff66bef4),
                                                                  Color(
                                                                      0xff2a58e5)
                                                                ],
                                                                stops: [
                                                                  0.1,
                                                                  0.6
                                                                ],
                                                                begin: Alignment
                                                                    .topLeft,
                                                                end: Alignment
                                                                    .bottomRight,
                                                              ),
                                                              shape: BoxShape
                                                                  .circle),
                                                      child: MaterialButton(
                                                          shape:
                                                              const CircleBorder(),
                                                          onPressed: () {
                                                            if (selectedAnswerIndex !=
                                                                null) {
                                                              //Calculating and replacing the points in the answer points map
                                                              double point = double
                                                                  .parse(receivedQuiz[
                                                                          index]
                                                                      .answers[
                                                                          selectedAnswerIndex!]
                                                                      .mark);
                                                              qandAData.add(QuizResultModel(
                                                                  questionId: receivedQuiz[
                                                                          index]
                                                                      .questionId,
                                                                  mark: point,
                                                                  answerId: receivedQuiz[
                                                                          index]
                                                                      .answers[
                                                                          selectedAnswerIndex!]
                                                                      .answerId));
                                                              //First the selected index will be assigned to null, because then it will not display any selected options
                                                              selectedAnswerIndex =
                                                                  null;
                                                              questionPageController.nextPage(
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          500),
                                                                  curve: Curves
                                                                      .ease);
                                                            } else {
                                                              noSelectedOptionDialog();
                                                            }
                                                          },
                                                          child: const Icon(
                                                            Icons.arrow_forward,
                                                            color: Colors.white,
                                                            size: 40,
                                                          )),
                                                    )
                                                  : Form(
                                                      child: Container(
                                                        decoration:
                                                            const BoxDecoration(
                                                                gradient:
                                                                    LinearGradient(
                                                                  colors: [
                                                                    Color(
                                                                        0xff66bef4),
                                                                    Color(
                                                                        0xff2a58e5)
                                                                  ],
                                                                  stops: [
                                                                    0.1,
                                                                    0.6
                                                                  ],
                                                                  begin: Alignment
                                                                      .topLeft,
                                                                  end: Alignment
                                                                      .bottomRight,
                                                                ),
                                                                shape: BoxShape
                                                                    .circle),
                                                        child: MaterialButton(
                                                            shape:
                                                                const CircleBorder(),
                                                            onPressed: () {
                                                              if (_dayformKey
                                                                  .currentState!
                                                                  .validate()) {
                                                                //The test_score and no_of_days will be send to a function and the result map will be generated
                                                                //the result map will be send as a parameter of the confirmSubmitDialog() function

                                                                ResultCalculation
                                                                    resultCalc =
                                                                    ResultCalculation(
                                                                        qandAData,
                                                                        int.parse(dayController
                                                                            .text),
                                                                        receivedQuiz
                                                                            .length);

                                                                confirmSubmitDialog(
                                                                    resultCalc
                                                                        .resultMapGenerator());
                                                              }
                                                            },
                                                            child: const Icon(
                                                              Icons
                                                                  .check_outlined,
                                                              color:
                                                                  Colors.white,
                                                              size: 40,
                                                            )),
                                                      ),
                                                    )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]),
                              ),
                            )
                          ]);
                        }, // Disable swipe gestures to navigate to the previous page
                        physics: const NeverScrollableScrollPhysics(),
                      ),
                    ),
                  ),
      ),
    );
  }

  //Creating the alert dialog box to display if user didnt select any option
  void noSelectedOptionDialog() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        title: 'No Answer Selected',
        text: 'Please select an answer');
  }

  //Creating the dialog box to confirm that the user wants to quit
  void quitOptionDialog() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        title: 'Do You Want To Quit ?',
        text: 'Any of the selected answers will not be saved !',
        confirmBtnText: 'Quit',
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });
  }

  //Creating the dialog box to confirm that the user wnats to see the results
  void confirmSubmitDialog(Map<String, dynamic> quizResultMap) {
    for (QuizResultModel i in qandAData) {
      print('${i.questionId}, ${i.answerId}, ${i.mark}');
    }
    print(quizResultMap);

    QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        title: 'Submit The Answers ?',
        text: 'Proceed to submit the answers and see the results',
        confirmBtnText: 'Proceed',
        onConfirmBtnTap: () {
          //the reult map will be send as a parameter of the submitResultData() function
          submitResultData(quizResultMap, context);
        });
  }

  void quizUpdatingAlert() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        title: 'Quiz Is Under Maintenance !',
        text: 'Quiz is under maintanence, please try again later.',
        barrierDismissible: false,
        disableBackBtn: true,
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });
  }

  void quizUpdatedAlert() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        title: 'Quiz Has Been Updated !',
        text: 'The quiz has been updated recently, please retake the quiz',
        barrierDismissible: false,
        disableBackBtn: true,
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });
  }

  //Creating the function to request the quiz
  Future<void> requestQuiz(BuildContext context) async {

    if (context.mounted) {
      if (await checkLoginStatus(context)) {
        try {
          String? accessToken = await retrieveAccessToken();

          // Obtaining the URL to a variable
          String apiUrl = (await ReadApiEndpoints.readApiEndpointsData())["requestQuizEndpoint"];

          //Converting the url to uri
          Uri uri = Uri.parse(apiUrl);

          //Requesting the quiz
          final response = await http.get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $accessToken'
            },
          );

          //Returning an output according to the status code
          if (response.statusCode == 200) {
            //Decode the received quiz and store in the quiz model
            final data = json.decode(response.body);

            if (context.mounted) {
              setState(() {
                //Storing the decode data in the model instance we created at the beginning
                receivedQuiz = List.from(data['questions_and_answers'])
                    .map<QuizModel>((item) {
                  return QuizModel(
                    questionId: item['id'],
                    question: item['question'],
                    answers:
                        List.from(item['answers']).map<AnswerModel>((answer) {
                      return AnswerModel(
                          answerId: answer['id'],
                          answer: answer['answer'],
                          mark: answer['mark']);
                    }).toList(),
                  );
                }).toList();

                //Setting the last_updated_timestamp in secure storage
                storeLastUpdatedTimestamp(data['last_updated_timestamp']);

                print(data['last_updated_timestamp']);

                //Considering the page as loaded
                isLoading = false;
              });
            }
          } else {
            final data = json.decode(response.body);

            if (data.containsKey('quiz_updating')) {
              quizUpdatingAlert();
            } else {
              print('unable to receive data: ${response.body}');
            }
          }
        } catch (e) {
          print("Exception Occured: $e");
        }
      }
    }
  }

  //Creating the function to submit the result data
  //This function will get the result map as the parameter and directly send it to the backend
  Future<void> submitResultData(
      Map<String, dynamic> quizResultMap, BuildContext context) async {
    Navigator.of(context).pop();
    loadingDialog();

    String? lastUpdatedTimestamp = await retrieveLastUpdatedTimestamp();

    if (lastUpdatedTimestamp != null) {
      if (context.mounted) {
        if (await checkLoginStatus(context)) {
          try {
            String? accessToken = await retrieveAccessToken();

            // Obtaining the URL to a variable
            String apiUrl = (await ReadApiEndpoints.readApiEndpointsData())["quizResultStoreEndpoint"];

            //Converting the url to uri
            Uri uri = Uri.parse(apiUrl);

            //Creating the relavant data map to send
            final List<Map<String, dynamic>> quizQandAList = [];

            for (int i = 0; i < qandAData.length; i++) {
              quizQandAList.add({
                'question': qandAData[i].questionId,
                'answer_id': qandAData[i].answerId
              });
            }

            Map<String, dynamic> formData = {
              'quiz_result_data': quizResultMap,
              'quiz_q_and_a_data': quizQandAList,
              'last_updated_timestamp': lastUpdatedTimestamp,
            };

            //Sending the result map to the backend with the token
            final response = await http.post(
              uri,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $accessToken'
              },
              body: json.encode(formData),
            );

            //Returning an output according to the status code
            if (response.statusCode == 201) {
              print('Data submitted successfully');

              // Decode the response data
              final Map<String, dynamic> responseData =
                  json.decode(response.body);

              if (context.mounted) {
                Navigator.of(context).pop();
                //If the result data are submitted suceesfully, navigate to a loading screen by sending the quiz result id with it
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QuizResultPage(
                            quizResultId: responseData['quiz_result_id'])));
              }
            } else {
              final data = json.decode(response.body);

              if (data.containsKey('quiz_updating')) {
                if (context.mounted) {
                  Navigator.of(context).pop();
                  quizUpdatingAlert();
                }
              } else if (data.containsKey('quiz_updated')) {
                if(context.mounted) {
                  Navigator.of(context).pop();
                  quizUpdatedAlert();
                }
              } else {
                print('unable to receive data: ${response.body}');
              }
            }
          } catch (e) {
            print("Exception Occured: $e");
          }
        }
      }
    } else {
      print('Last updated timestamp is null');
    }
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

//The model that stores quiz results of the user
class QuizResultModel {
  int questionId;
  int answerId;
  double mark;

  QuizResultModel(
      {required this.questionId, required this.mark, required this.answerId});
}

//The model that is used to store the quiz
class QuizModel {
  final int questionId;
  final String question;
  final List<AnswerModel> answers;

  QuizModel(
      {required this.questionId,
      required this.question,
      required this.answers});
}

//The model that stores the answers
class AnswerModel {
  final int answerId;
  final String answer;
  final String mark;

  AnswerModel({
    required this.answerId,
    required this.answer,
    required this.mark,
  });
}
