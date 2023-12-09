import 'package:flutter/material.dart';
import 'package:tsd_project/screen/home_page.dart';
import 'package:tsd_project/screen/login.dart';
import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tsd_project/quiz_receiver.dart';
import 'package:tsd_project/result_calculation.dart';
import 'package:tsd_project/screen/result_page.dart';

//The model that stores quiz results of the user
class QuizResultModel {
  int questionId;
  int answerId;
  double mark;

  QuizResultModel(
      {required this.questionId, required this.mark, required this.answerId});
}

class QuizPage extends StatefulWidget {
  final List<QuizModel> quiz;

  QuizPage({required this.quiz});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  //Creating a page Controller
  PageController questionPageController = PageController(initialPage: 0);

  //Adjusting the answer button color
  int? selectedAnswerIndex;

  //Creating a text controller to get the no.of days
  TextEditingController dayController = TextEditingController();

  //Creating a global form key to validate the day input form
  final GlobalKey<FormState> _dayformKey = GlobalKey<FormState>();

  //Creating the list to store the answers of the user (question id, answer id, mark)
  List<QuizResultModel> answerPoints = [];

  //Declaring the secure storage where we stored the token in the login page
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  //These two functions are used to check whether the user logged in
  //This function will call the checkLoginState() and requestQuiz() functions at the beggining of the page
  @override
  void initState() {
    super.initState();
    Future.microtask(() => checkLoginStatus());
  }

  //This function will check if the token is null, and if it is null, then redirects to the login page
  Future<void> checkLoginStatus() async {
    String? token = await secureStorage.read(key: 'token');

    if (token != null) {
      print('User is logged in');
    } else {
      print('user is not logged in');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => login_user()));
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
        //Creating a pageview
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: screenWidth,
            ),
            decoration: BoxDecoration(color: Color(0xE51FC0E7)),
            child: PageView.builder(
              //Assigning the questionPageController as the controller
              controller: questionPageController,
              //The no.of questions must be stored in itemcount (including the day question)
              itemCount: widget.quiz.length + 1,
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
                      padding: const EdgeInsets.fromLTRB(30.0, 0, 30, 30),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //Displaying the question number and the quit button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //Displaying the question number
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 0, 0, 0),
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
                                                            color:
                                                                Color.fromRGBO(
                                                                    0,
                                                                    0,
                                                                    0,
                                                                    0.5),
                                                            offset:
                                                                Offset(4, 4),
                                                            blurRadius: 4)
                                                      ],
                                                          color: Color.fromRGBO(
                                                              0,
                                                              57,
                                                              255,
                                                              0.8))),
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
                                                          color: Color.fromRGBO(
                                                              0, 0, 0, 0.5),
                                                          offset: Offset(4, 4),
                                                          blurRadius: 4)
                                                    ],
                                                    color: Color.fromARGB(
                                                        255, 246, 241, 241),
                                                  )),
                                            )),
                                        Positioned(
                                            top: 73,
                                            left: 8,
                                            child: Text(
                                              '${(index + 1) < 10 ? '0${index + 1}' : index + 1}',
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                  color: Color.fromRGBO(
                                                      0, 57, 255, 1),
                                                  fontFamily: 'ArchivoBlack',
                                                  fontSize: 35,
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.normal,
                                                  height: 1),
                                            )),
                                      ])),
                                ),

                                //Displaying the quit button
                                MaterialButton(
                                    shape: const CircleBorder(),
                                    color: const Color(0xFF0039FF),
                                    onPressed: () {
                                      //Disaplying the dialog to confirm the quiting and to redirect to home screen
                                      quitOptionDialog();
                                    },
                                    child: Transform.rotate(
                                      angle: pi,
                                      child: const Icon(
                                        Icons.exit_to_app_rounded,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    )),
                              ],
                            ),

                            //Displaying the question
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color:
                                            Color.fromRGBO(0, 57, 255, 0.898),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(75),
                                          topRight: Radius.circular(75),
                                          bottomLeft: Radius.circular(75),
                                          bottomRight: Radius.circular(75),
                                        )),
                                    child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        //if it is not the last page, display normal questions. Otherwise, display day question
                                        child: index != widget.quiz.length
                                            ? Text(
                                                widget.quiz[index].question,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Archivo',
                                                    fontSize: 20,
                                                    letterSpacing: 0,
                                                    fontWeight: FontWeight.bold,
                                                    height: 1),
                                              )
                                            : const Text(
                                                'For how many days did you encounter these issues ?',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Archivo',
                                                    fontSize: 20,
                                                    letterSpacing: 0,
                                                    fontWeight: FontWeight.bold,
                                                    height: 1),
                                              )),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 20.0,
                            ),

                            //Displaying answer buttons or the text form field
                            index != widget.quiz.length
                                ? SizedBox(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      //This is an another way to generate the same result as a for loop (List.generate method)
                                      children: List.generate(
                                        widget.quiz[index].answers.length,
                                        (i) => Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 10, 0, 10),
                                          child: MaterialButton(
                                            height: 45,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(75),
                                            ),
                                            onPressed: () {
                                              //When setState function is executed the build widget will run again. This time it will run with selectedAnswerIndex = i
                                              setState(() {
                                                selectedAnswerIndex = i;
                                              });
                                            },
                                            color: selectedAnswerIndex == i
                                                ? const Color.fromRGBO(
                                                    0, 57, 255, 0.898)
                                                : Colors.white,
                                            child: Row(
                                              children: [
                                                //Displaying the circle shape in front of the answer in the button
                                                Container(
                                                    width: 15,
                                                    height: 15,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          selectedAnswerIndex ==
                                                                  i
                                                              ? Colors.white
                                                              : const Color
                                                                  .fromRGBO(19,
                                                                  54, 182, 1),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.elliptical(
                                                                  15, 15)),
                                                    )),
                                                const SizedBox(
                                                  width: 10.0,
                                                ),
                                                //Displaying the answer inside the button
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15.0),
                                                    child: Text(
                                                      //The answers of the related question is stored in a map, this will get all the keys of the map and will put them into a list. Then get the related indexed one.
                                                      widget.quiz[index]
                                                          .answers[i].answer,
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          color:
                                                              selectedAnswerIndex ==
                                                                      i
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                          fontFamily: 'Archivo',
                                                          fontSize: 20,
                                                          letterSpacing: 0,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          height: 1),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        30, 30, 30, 10),
                                    child: Form(
                                        key: _dayformKey,
                                        child: Container(
                                          constraints: const BoxConstraints(
                                            maxWidth: 300.0,
                                          ),
                                          child: TextFormField(
                                            controller: dayController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              hintText: 'No.Of Days',
                                              prefixIcon:
                                                  const Icon(Icons.date_range),
                                              filled: true,
                                              fillColor: Colors.white,
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                borderSide: const BorderSide(
                                                    color: Colors.red,
                                                    width: 2),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                borderSide: const BorderSide(
                                                    color: Colors.red,
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
                                    MaterialButton(
                                        shape: const CircleBorder(),
                                        color: const Color(0xFF0039FF),
                                        onPressed: () {
                                          //First the selected index will be assigned to null, because then it will not display any selected options
                                          selectedAnswerIndex = null;

                                          if (answerPoints.isNotEmpty) {
                                            answerPoints.removeLast();
                                          }

                                          questionPageController.previousPage(
                                              duration: const Duration(
                                                  milliseconds: 30),
                                              curve: Curves.bounceOut);
                                        },
                                        child: const Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,
                                          size: 40,
                                        )),

                                    //If it is not the last page, then display next button. Otherwise, display submit button
                                    index != widget.quiz.length
                                        ? MaterialButton(
                                            shape: const CircleBorder(),
                                            color: const Color(0xFF0039FF),
                                            onPressed: () {
                                              if (selectedAnswerIndex != null) {
                                                //Calculating and replacing the points in the answer points map
                                                double point = double.parse(
                                                    widget
                                                        .quiz[index]
                                                        .answers[
                                                            selectedAnswerIndex!]
                                                        .mark);
                                                answerPoints.add(QuizResultModel(
                                                    questionId: widget
                                                        .quiz[index].questionId,
                                                    mark: point,
                                                    answerId: widget
                                                        .quiz[index]
                                                        .answers[
                                                            selectedAnswerIndex!]
                                                        .answerId));
                                                //First the selected index will be assigned to null, because then it will not display any selected options
                                                selectedAnswerIndex = null;
                                                questionPageController.nextPage(
                                                    duration: const Duration(
                                                        milliseconds: 30),
                                                    curve: Curves.bounceIn);
                                              } else {
                                                noSelectedOptionDialog();
                                              }
                                            },
                                            child: const Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white,
                                              size: 40,
                                            ))
                                        : Form(
                                            child: MaterialButton(
                                                shape: const CircleBorder(),
                                                color: const Color(0xFF0039FF),
                                                onPressed: () {
                                                  if (_dayformKey.currentState!
                                                      .validate()) {
                                                    //The test_score and no_of_days will be send to a function and the result map will be generated
                                                    //the result map will be send as a parameter of the confirmSubmitDialog() function

                                                    ResultCalculation
                                                        resultCalc =
                                                        ResultCalculation(
                                                            answerPoints,
                                                            int.parse(
                                                                dayController
                                                                    .text),
                                                            widget.quiz.length);

                                                    confirmSubmitDialog(resultCalc
                                                        .resultMapGenerator());
                                                  }
                                                },
                                                child: const Icon(
                                                  Icons.check_outlined,
                                                  color: Colors.white,
                                                  size: 40,
                                                )),
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
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFF0039FF), width: 5)),
            title: const Text('No Answer Selected'),
            content: const Text('Please select an answer before continuing'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      color: Color(0xFF0039FF),
                    ),
                  ))
            ],
          );
        });
  }

  //Creating the dialog box to confirm that the user wants to quit
  void quitOptionDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFF0039FF), width: 5)),
            title: const Text('Do You Want To Exit ?'),
            content:
                const Text('Any of the selected answers will not be saved !'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyHomePage(
                                  title: 'abc',
                                )));
                  },
                  child: const Text(
                    'Yes',
                    style: TextStyle(color: Color(0xFF0039FF)),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(color: Color(0xFF0039FF)),
                  ))
            ],
          );
        });
  }

  //Creating the dialog box to confirm that the user wnats to see the results
  void confirmSubmitDialog(Map<String, dynamic> resultMap) {
    for (QuizResultModel i in answerPoints) {
      print('${i.questionId}, ${i.answerId}, ${i.mark}');
    }
    print(resultMap);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFF0039FF), width: 5)),
            title: const Text('Do You Want To See The Results?'),
            content:
                const Text('Please proceed if you want to see the results.'),
            actions: [
              TextButton(
                  onPressed: () {
                    //the reult map will be send as a parameter of the submitResultData() function
                    submitResultData(resultMap);
                  },
                  child: const Text(
                    'Proceed',
                    style: TextStyle(color: Color(0xFF0039FF)),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(
                      color: Color(0xFF0039FF),
                    ),
                  ))
            ],
          );
        });
  }

  //Creating the function to submit the result data
  //This function will get the result map as the parameter and directly send it to the backend
  Future<void> submitResultData(Map<String, dynamic> resultMap) async {
    //Collecting the token from the secure storage
    String? token = await secureStorage.read(key: 'token');

    //If the token is not null continue with the process
    if (token != null) {
      // Obtaining the URL to a variable
      final String apiUrl = 'http://10.0.2.2:8000/store_result/';

      //Converting the url to uri
      Uri uri = Uri.parse(apiUrl);

      //Sending the result map to the backend with the token
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode(resultMap),
      );

      //Returning an output according to the status code
      if (response.statusCode == 201) {
        print('Data submitted successfully');
        //If the result data are submitted suceesfully, navigate to a loading screen
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ResultPage(resultMap: resultMap)));
      } else {
        print('unable to submit data: ${response.body}');
      }
    } else {
      print("The token is null");
    }
  }
}
