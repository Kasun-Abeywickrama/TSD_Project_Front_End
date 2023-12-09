import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ResultPage extends StatefulWidget {
  //Declaring the map that must be received when navigating
  final Map<String, dynamic> resultMap;

  //Declaring the Constructor for the map
  const ResultPage({required this.resultMap});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  //Declaring varaibles to store the result data, these will be displayed in this page
  String? date = '';
  String? time = '';
  double testScore = 0.0;
  String depressionLevel = '';
  String conclusion = '';

  //Initializing the flutter secure storage
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  //Creating the function that sets the relavant fields
  void setResultData() async {
    //Check if the result map contains date or time
    if (widget.resultMap.containsKey('date') ||
        widget.resultMap.containsKey('time')) {
      //If it contains that,
      //Declaring the requested result date and time.
      final Map<String, dynamic> resultDateTime = {
        'date': widget.resultMap['date'],
        'time': widget.resultMap['time'],
      };

      //This process Fetches the data from the backend
      String? token = await secureStorage.read(key: 'token');
      if (token != null) {
        try {
          // Obtaining the URL to a variable
          final String apiUrl = 'http://10.0.2.2:8000/view_result/';

          //Converting the url to uri
          Uri uri = Uri.parse(apiUrl);

          //Requesting the data from the backend and sending the date,time, jwt token
          final response = await http.post(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: json.encode(resultDateTime),
          );

          if (response.statusCode == 200) {
            //Decode the response
            final Map<String, dynamic> backendResultMap =
                json.decode(response.body);
            //Intializing these variables and rebuild the build method
            setState(() {
              date = backendResultMap['date'];
              time = backendResultMap['time'];
              testScore = double.parse(backendResultMap['test_score']);
              depressionLevel = backendResultMap['depression_level'];
              conclusion = backendResultMap['conclusion'];
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
      //If the resultMap does not have date or time, then it is redirecting from quiz. Therefore set the other variables.
    } else {
      date = null;
      time = null;
      testScore = widget.resultMap['test_score'];
      depressionLevel = widget.resultMap['depression_level'];
      conclusion = widget.resultMap['conclusion'];
    }
  }

  //exceuting the setResultData() when page begins (only the first time)
  @override
  void initState() {
    super.initState();
    setResultData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
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
                                  color: Color.fromRGBO(0, 0, 0, 0.25),
                                  offset: Offset(5, 5),
                                  blurRadius: 4)
                            ],
                            color: Color.fromRGBO(
                                255, 255, 255, 0.8899999856948853),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              //If the date is not null, display the relavant backend data
                              child: date != null
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                          Expanded(
                                            flex: 5,
                                            child: Column(
                                              children: [
                                                Text(
                                                  date!,
                                                  textAlign: TextAlign.center,
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
                                                  time!,
                                                  style: const TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ])
                                  //If the date is null display "Your Result"
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Your Result',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 20,
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
                                  color: Color.fromRGBO(0, 0, 0, 0.25),
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
                                              fontWeight: FontWeight.bold),
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
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      children: [
                                        Text(
                                          '$testScore%',
                                          style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
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
                                  color: Color.fromRGBO(0, 0, 0, 0.25),
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
                                              fontWeight: FontWeight.bold),
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
                                          depressionLevel,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
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
                                  color: Color.fromRGBO(0, 0, 0, 0.25),
                                  offset: Offset(5, 5),
                                  blurRadius: 4)
                            ],
                            color: Color.fromRGBO(
                                255, 255, 255, 0.8899999856948853),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(children: [
                              Expanded(
                                  child: Text(
                                conclusion,
                                style: const TextStyle(fontSize: 17),
                              ))
                            ]),
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
