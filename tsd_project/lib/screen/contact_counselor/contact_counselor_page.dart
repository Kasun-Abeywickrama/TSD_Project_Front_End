import 'package:flutter/material.dart';
import 'package:tsd_project/decoration_tools/top_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactCounselor extends StatefulWidget {
  const ContactCounselor({super.key});

  @override
  State<ContactCounselor> createState() => _ContactCounselorState();
}

class _ContactCounselorState extends State<ContactCounselor> {
  //This counselor details must be taken from the backend for the given admin details id
  final Map<String, dynamic> counselorDetails = {
    'first_name': 'Prasanna',
    'last_name': 'Aththanayaka',
    'location': 'Colombo 7',
    'mobile_phone': '076340789',
    'email': 'prasanna@gmail.com',
    'website': 'https://www.google.com',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTopAppBar(
        pageIndex: 1,
        pageName: "Contact Counselor",
      ),
      body: Container(
        color: Colors.white,
        child: ListView(children: [
          Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ClipOval(
                    child: SizedBox(
                      height: 150,
                      width: 150,
                      child: Image.asset(
                        //Replace with the actual doctors image
                        "assets/images/doctor.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
           //

          const SizedBox(height: 10), // Adding space between text and image
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0, 30, 30),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 450),
              decoration: const BoxDecoration(
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
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 30),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Name : ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(3, 71, 120, 1),
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(25.0, 0, 0, 0),
                              child: Text(
                                '${counselorDetails['first_name']} ${counselorDetails['last_name']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(3, 71, 120, 1),
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      const Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Location : ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(3, 71, 120, 1),
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(25.0, 0, 0, 0),
                              child: Text(
                                counselorDetails['location'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(3, 71, 120, 1),
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      const Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Phone : ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(3, 71, 120, 1),
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(25.0, 0, 0, 0),
                              child: Text(
                                counselorDetails['mobile_phone'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(3, 71, 120, 1),
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      const Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Email : ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(3, 71, 120, 1),
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(25.0, 0, 0, 0),
                              child: Text(
                                counselorDetails['email'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(3, 71, 120, 1),
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      const Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Website : ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(3, 71, 120, 1),
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                              child: InkWell(
                                onTap: () => launchWebsiteURL(
                                    counselorDetails['website']),
                                child: Text(
                                  counselorDetails['website'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromRGBO(3, 71, 120, 1),
                                      fontSize: 18,
                                      decoration: TextDecoration.underline,
                                      decorationThickness: 1.5,
                                      decorationColor:
                                          Color.fromRGBO(3, 71, 120, 1)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xff2a58e5),
                                  Color(0xff66bef4),
                                ],
                                stops: [0.5, 1],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )),
                          height: 45,
                          constraints: const BoxConstraints(
                            maxWidth: 450.0,
                          ),
                          child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              onPressed: () {
                                //Make the appointment
                              },
                              child: const Text(
                                'Make Appointment',
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
            ],
          ),
        ]
        ),
      ),
    );
  }

  //Function to run the website URL
  launchWebsiteURL(String url) async {
    //The try catch block will catch any errors of launching website url
    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      print("could not launch url : $url");
    }
  }
}
