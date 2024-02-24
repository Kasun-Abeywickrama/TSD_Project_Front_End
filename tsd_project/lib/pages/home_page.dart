import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';
import 'package:tsd_project/decoration_tools/custom_loading_indicator.dart';
import 'package:tsd_project/pages/private_guidance/request_guidance_page.dart';
import 'package:tsd_project/pages/quiz/quiz_page.dart';
import 'package:tsd_project/important_tools/user_authentication.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../important_tools/api_endpoints.dart';

class HomePage extends StatefulWidget {
  //When a new unique key is passed, the widget page will rebuild including the initial process method
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //String to store the greeting
  String greeting = 'Nice to see you';

  //Declaring the variable to check if the page is loading
  bool isLoading = true;

  //Declaring variables to store the user personal details
  String? firstName;

  //Function that gets the existing data from the database
  Future<void> setPersonalDetails(BuildContext context) async {
    //This process Fetches the data from the backend

    if (context.mounted) {
      if (await checkLoginStatus(context)) {
        try {
          String? accessToken = await retrieveAccessToken();

          // Obtaining the URL to a variable
          String apiUrl = (await ReadApiEndpoints.readApiEndpointsData())["requestPatientPersonalDetailsEndpoint"];

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

            if (context.mounted) {
              //Intializing these variables and rebuild the build method
              setState(() {
                if (backendUserDetails['patient_personal_details']
                        ['first_name'] !=
                    null) {
                  firstName = backendUserDetails['patient_personal_details']
                      ['first_name'];
                }

                //Considering the page is loaded
                isLoading = false;
              });
            }
          } else {
            print('Failed to receive data ${response.body}');
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
        setPersonalDetails(context);
        greeting = getGreeting();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CustomLoadingIndicator()
        : ListView(
            children: [
              SizedBox(
                width: double.infinity,
                // color: Colors.blueAccent,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 60,
                        margin: const EdgeInsets.only(
                            top: 10.0, right: 25.0, left: 25.0),
                        child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.lato(
                                        fontSize: 30.0, color: Colors.black),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '$greeting, ',
                                      ),
                                      TextSpan(
                                        text: firstName ?? 'Friend',
                                        style: GoogleFonts.pacifico(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const TextSpan(
                                        text: '!',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                // color: Colors.grey,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(
                          top: 10.0, right: 25.0, left: 25.0),
                      // color: Colors.teal,
                      child: const Text(
                        "How are you feeling today ?",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    Container(
                      height: 120.0,
                      margin: const EdgeInsets.only(left: 25.0, top: 15.0),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          GestureDetector(
                            onTap: () {
                              feelingInfoDialog("Happy");
                            },
                            child: Container(
                              width: 80.0,
                              margin: const EdgeInsets.only(right: 22.0),
                              child: Image.asset(
                                'assets/images/Happy.png', // Path to your image in the assets folder
                                fit: BoxFit
                                    .cover, // Adjust the fit as needed (cover, contain, etc.)
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              feelingInfoDialog("Calm");
                            },
                            child: Container(
                              width: 80.0,
                              margin: const EdgeInsets.only(right: 22.0),
                              child: Image.asset(
                                'assets/images/Calm.png', // Path to your image in the assets folder
                                fit: BoxFit
                                    .cover, // Adjust the fit as needed (cover, contain, etc.)
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              feelingInfoDialog("Manic");
                            },
                            child: Container(
                              width: 80.0,
                              margin: const EdgeInsets.only(right: 22.0),
                              child: Image.asset(
                                'assets/images/Relax.png', // Path to your image in the assets folder
                                fit: BoxFit
                                    .cover, // Adjust the fit as needed (cover, contain, etc.)
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              feelingInfoDialog("Angry");
                            },
                            child: Container(
                              width: 80.0,
                              margin: const EdgeInsets.only(right: 22.0),
                              child: Image.asset(
                                'assets/images/Angry.png', // Path to your image in the assets folder
                                fit: BoxFit
                                    .cover, // Adjust the fit as needed (cover, contain, etc.)
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              feelingInfoDialog("Sad");
                            },
                            child: Container(
                              width: 80.0,
                              margin: const EdgeInsets.only(right: 22.0),
                              child: Image.asset(
                                'assets/images/Sad.png', // Path to your image in the assets folder
                                fit: BoxFit
                                    .cover, // Adjust the fit as needed (cover, contain, etc.)
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 20.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(
                              153, 212, 255, 0.5600000023841858),
                          borderRadius: BorderRadius.circular(
                              20.0), // Set the border radius
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 7, // 70% width
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        'Take The Quiz',
                                        style: GoogleFonts.lato(
                                            fontSize: 22.0,
                                            color: const Color(0xFF573926),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Text(
                                        'Let’s open up to the things that matter the most ',
                                        style: GoogleFonts.lato(
                                            fontSize: 17.0,
                                            color: const Color(0xFF573926)),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 20.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              (MaterialPageRoute(
                                                  builder: (context) =>
                                                      QuizPage())));
                                        },
                                        child: Text(
                                          'Start the quiz',
                                          style: GoogleFonts.lato(
                                              fontSize: 22.0,
                                              color: const Color(0xFF0289EB),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 3, // 30% width
                                child: Center(
                                  child: Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(right: 22.0),
                                    child: Image.asset(
                                      'assets/images/Quiz.png', // Path to your image in the assets folder
                                      fit: BoxFit
                                          .cover, // Adjust the fit as needed (cover, contain, etc.)
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCDDEC),
                          borderRadius: BorderRadius.circular(
                              20.0), // Set the border radius
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 7, // 70% width
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        'Request Guidance',
                                        style: GoogleFonts.lato(
                                            fontSize: 22.0,
                                            color: const Color(0xFF86593D),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Text(
                                        'If you have any issues, please feel free to contact the counselors',
                                        style: GoogleFonts.lato(
                                            fontSize: 17.0,
                                            color: const Color(0xFF86593D)),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 20.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              (MaterialPageRoute(
                                                  builder: (context) =>
                                                      RequestGuidancePage())));
                                        },
                                        child: Text(
                                          'Request Guidance',
                                          style: GoogleFonts.lato(
                                              fontSize: 22.0,
                                              color: const Color(0xFF86593D),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 3, // 30% width
                                child: Center(
                                  child: Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(right: 22.0),
                                    child: Image.asset(
                                      'assets/images/sample.png', // Path to your image in the assets folder
                                      fit: BoxFit
                                          .cover, // Adjust the fit as needed (cover, contain, etc.)
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }

  //The function that returns greeting
  String getGreeting() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 18) {
      return 'Good Afternoon';
    } else if (hour < 22) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  //Dialog boxes for the feelings
  void feelingInfoDialog(String feeling) {
    String title;
    String text;

    if (feeling == 'Happy') {
      title = "Feeling Happy !";
      text = "Happiness is a wonderful feeling!";
    } else if (feeling == 'Calm') {
      title = "Feeling Calm !";
      text =
          'Find a quiet space. Breathe deeply and let calmness wash over you.';
    } else if (feeling == 'Manic') {
      title = "Feeling Manic !";
      text = "Feeling energized? Channel that energy into something positive!";
    } else if (feeling == 'Angry') {
      title = "Feeling Angry !";
      text = "Take a deep breath. Anger is a natural emotion.";
    } else {
      title = "Feeling Sad !";
      text = "It's okay to feel sad. Reach out to someone you trust.";
    }

    QuickAlert.show(
        context: context, type: QuickAlertType.info, title: title, text: text);
  }
}
