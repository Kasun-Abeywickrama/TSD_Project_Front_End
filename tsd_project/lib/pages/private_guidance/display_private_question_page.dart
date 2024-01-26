import 'package:flutter/material.dart';
import 'package:tsd_project/decoration_tools/top_app_bar.dart';
import 'package:tsd_project/important_tools/user_authentication.dart';

class DisplayPrivateQuestionPage extends StatefulWidget {
  final Map<String, dynamic> privateQuestionDetails;

  DisplayPrivateQuestionPage({super.key, required this.privateQuestionDetails});

  @override
  State<DisplayPrivateQuestionPage> createState() =>
      _DisplayPrivateQuestionPageState();
}

class _DisplayPrivateQuestionPageState
    extends State<DisplayPrivateQuestionPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => checkLoginStatus(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTopAppBar(
        pageIndex: 1,
        pageName: "Request Guidance",
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: ListView(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 40, 30, 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Column(
                                        children: [
                                          Text(
                                            widget.privateQuestionDetails[
                                                'asked_date'],
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontSize: 17,
                                                color: Color.fromRGBO(
                                                    3, 71, 120, 1),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Column(
                                        children: [
                                          Text(
                                            widget.privateQuestionDetails[
                                                'asked_time'],
                                            style: const TextStyle(
                                                fontSize: 17,
                                                color: Color.fromRGBO(
                                                    3, 71, 120, 1),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ])),
                        ),
                        const SizedBox(
                          height: 18.0,
                        ),
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
                                            "Counselor : ",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Color.fromRGBO(
                                                    3, 71, 120, 1),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Column(
                                        children: [
                                          Text(
                                            "${widget.privateQuestionDetails['counselor_first_name']} ${widget.privateQuestionDetails['counselor_last_name']}",
                                            style: const TextStyle(
                                                fontSize: 17,
                                                color: Color.fromRGBO(
                                                    3, 71, 120, 1),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ])),
                        ),
                        const SizedBox(
                          height: 18.0,
                        ),
                        // Container
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
                            child: Row(children: [
                              Expanded(
                                  child: Text(
                                "Question :  \n\n${widget.privateQuestionDetails['private_question']}",
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(3, 71, 120, 1)),
                              ))
                            ]),
                          ),
                        ),
                        const SizedBox(
                          height: 18.0,
                        ),

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
                            child: Row(children: [
                              Expanded(
                                  child: Text(
                                "Answer :  \n\n${widget.privateQuestionDetails['private_answer']}",
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(3, 71, 120, 1)),
                              ))
                            ]),
                          ),
                        )
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
