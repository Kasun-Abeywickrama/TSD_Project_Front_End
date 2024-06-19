import 'package:flutter/material.dart';
import 'package:tsd_project/decoration_tools/top_app_bar.dart';
import 'package:tsd_project/important_tools/user_authentication.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../decoration_tools/custom_loading_indicator.dart';
import '../../important_tools/api_endpoints.dart';

class DisplayPrivateQuestionPage extends StatefulWidget {
  final Map<String, dynamic> privateQuestionDetails;

  DisplayPrivateQuestionPage({super.key, required this.privateQuestionDetails});

  @override
  State<DisplayPrivateQuestionPage> createState() =>
      _DisplayPrivateQuestionPageState();
}

class _DisplayPrivateQuestionPageState
    extends State<DisplayPrivateQuestionPage> {

  //Declaring the variable to check if the page is loading
  bool isLoading = true;

  Future<void> setPrivateQuestionIsPatientViewedTrue(BuildContext context) async {

    if (context.mounted) {
      if (await checkLoginStatus(context)) {
        try {
          String? accessToken = await retrieveAccessToken();

          // Obtaining the URL to a variable
          String apiUrl = (await ReadApiEndpoints.readApiEndpointsData())["makePrivateQuestionIsPatientViewedTrueEndpoint"];

          //Converting the url to uri
          Uri uri = Uri.parse(apiUrl);

          Map<String, dynamic> privateQuestionId = {
            'private_question_id': widget.privateQuestionDetails['private_question_id']
          };

          final response = await http.post(
            uri,
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            },
            body: json.encode(privateQuestionId),
          );

          if (response.statusCode == 201) {
            //Decode the response
            print(response.body);

            if (context.mounted) {
              //Intializing these variables and rebuild the build method
              setState(() {
                //Considering the page is loaded
                isLoading = false;
              });
            }
          } else {
            print('Failed to send data ${response.body}');
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
        setPrivateQuestionIsPatientViewedTrue(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    
    String askedTime = widget.privateQuestionDetails['asked_time'];
    
    return Scaffold(
      appBar: CustomTopAppBar(
        pageIndex: 1,
        pageName: "Request Guidance",
      ),
      body: isLoading
        ? CustomLoadingIndicator()
        :
      Container(
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
                                            askedTime.substring(0,8),
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
