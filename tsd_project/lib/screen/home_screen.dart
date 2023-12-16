import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tsd_project/bottom_navigation_bar.dart';
import 'package:tsd_project/screen/previous_quiz_results.dart';
import 'package:tsd_project/screen/quiz_page.dart';
import 'package:tsd_project/top_app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 320) {
      screenWidth = 320;
    }
    return Scaffold(
        bottomNavigationBar: CustomBottomNavigationBar(),
        appBar: CustomTopAppBar(),
        body: ListView(
          children: [
            Container(
              width: double.infinity,
              height: 80.0,
              // color: Colors.blueAccent,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: screenWidth,
                        ),
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.lato(
                                fontSize: 35.0, color: Colors.black),
                            children: <TextSpan>[
                              const TextSpan(
                                text: 'Good morning, ',
                              ),
                              TextSpan(
                                text: 'Sara',
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
                    )
                  ],
                ),
              ),
            ),
            Container(
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
                        Container(
                          width: 80.0,
                          margin: const EdgeInsets.only(right: 22.0),
                          child: Image.asset(
                            'assets/images/Happy.png', // Path to your image in the assets folder
                            fit: BoxFit
                                .cover, // Adjust the fit as needed (cover, contain, etc.)
                          ),
                        ),
                        Container(
                          width: 80.0,
                          margin: const EdgeInsets.only(right: 22.0),
                          child: Image.asset(
                            'assets/images/Calm.png', // Path to your image in the assets folder
                            fit: BoxFit
                                .cover, // Adjust the fit as needed (cover, contain, etc.)
                          ),
                        ),
                        Container(
                          width: 80.0,
                          margin: const EdgeInsets.only(right: 22.0),
                          child: Image.asset(
                            'assets/images/Relax.png', // Path to your image in the assets folder
                            fit: BoxFit
                                .cover, // Adjust the fit as needed (cover, contain, etc.)
                          ),
                        ),
                        Container(
                          width: 80.0,
                          margin: const EdgeInsets.only(right: 22.0),
                          child: Image.asset(
                            'assets/images/Angry.png', // Path to your image in the assets folder
                            fit: BoxFit
                                .cover, // Adjust the fit as needed (cover, contain, etc.)
                          ),
                        ),
                        Container(
                          width: 80.0,
                          margin: const EdgeInsets.only(right: 22.0),
                          child: Image.asset(
                            'assets/images/Sad.png', // Path to your image in the assets folder
                            fit: BoxFit
                                .cover, // Adjust the fit as needed (cover, contain, etc.)
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
                        child: Container(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 7, // 70% width
                                child: Container(
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
                                )),
                              ),
                              Expanded(
                                flex: 3, // 30% width
                                child: Container(
                                  child: Center(
                                    child: Container(
                                      width: double.infinity,
                                      margin:
                                          const EdgeInsets.only(right: 22.0),
                                      child: Image.asset(
                                        'assets/images/Quiz.png', // Path to your image in the assets folder
                                        fit: BoxFit
                                            .cover, // Adjust the fit as needed (cover, contain, etc.)
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                        child: Container(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 7, // 70% width
                                child: Container(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        'Previous Quiz Results',
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
                                        'Let’s see how you scored for your previous quizes',
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
                                                      PreviousQuizResults())));
                                        },
                                        child: Text(
                                          'View results',
                                          style: GoogleFonts.lato(
                                              fontSize: 22.0,
                                              color: const Color(0xFF86593D),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                              ),
                              Expanded(
                                flex: 3, // 30% width
                                child: Container(
                                  child: Center(
                                    child: Container(
                                      width: double.infinity,
                                      margin:
                                          const EdgeInsets.only(right: 22.0),
                                      child: Image.asset(
                                        'assets/images/sample.png', // Path to your image in the assets folder
                                        fit: BoxFit
                                            .cover, // Adjust the fit as needed (cover, contain, etc.)
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
