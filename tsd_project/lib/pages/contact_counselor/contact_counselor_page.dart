import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quickalert/quickalert.dart';
import 'package:tsd_project/decoration_tools/top_app_bar.dart';
import 'package:tsd_project/important_tools/api_endpoints.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../decoration_tools/custom_loading_indicator.dart';
import '../../important_tools/user_authentication.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ContactCounselorPage extends StatefulWidget {
  final int quizResultId;
  final Map<String, dynamic> counselorDetails;

  ContactCounselorPage({super.key, required this.quizResultId, required this.counselorDetails});

  @override
  State<ContactCounselorPage> createState() => _ContactCounselorPageState();
}

class _ContactCounselorPageState extends State<ContactCounselorPage> {

  bool canMakeAppointment = true;

  //Declaring the variable to check if the page is loading
  bool isLoading = true;

  //Initializing the flutter secure storage
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  //Function that gets the existing data from the database
  Future<void> checkOngoingAppointment(BuildContext context) async {
    //This process Fetches the data from the backend
    String? accessToken = await secureStorage.read(key: 'accessToken');

    if (context.mounted) {
      if (await checkLoginStatus(context)) {
        try {
          // Obtaining the URL to a variable
          const String apiUrl = checkOngoingAppointmentEndpoint;

          //Converting the url to uri
          Uri uri = Uri.parse(apiUrl);

          Map<String, dynamic> appointmentData = {
            'quiz_result' : widget.quizResultId,
            'admin' : widget.counselorDetails['admin_id'],
          };

          //Requesting the data from the backend
          final response = await http.post(
            uri,
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            },
            body: json.encode(appointmentData),
          );

          if (response.statusCode == 201) {
            //Decode the response
            print(response.body);
            final Map<String, dynamic> backendOngoingAppointment =
            json.decode(response.body);


            if (context.mounted) {
              //Intializing these variables and rebuild the build method
              setState(() {
                if (backendOngoingAppointment['can_make_appointment'] ==
                    "true") {
                  canMakeAppointment = true;
                }
                else{
                  canMakeAppointment = false;
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
      if(context.mounted){
        checkOngoingAppointment(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTopAppBar(
        pageIndex: 1,
        pageName: "Contact Counselor",
      ),
      body: isLoading
          ? CustomLoadingIndicator()
          :
            RefreshIndicator(
              onRefresh: () => initialProcess(context),
              child: Container(
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
                                        '${widget.counselorDetails['first_name']} ${widget.counselorDetails['last_name']}',
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
                                        widget.counselorDetails['location'],
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
                                        widget.counselorDetails['mobile_number'],
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
                                        widget.counselorDetails['email'],
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
                                            widget.counselorDetails['website']),
                                        child: Text(
                                          widget.counselorDetails['website'],
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

                                  decoration: canMakeAppointment ?
                                  BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xff2a58e5),
                                          Color(0xff66bef4),
                                        ],
                                        stops: [0.5, 1],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ))
                                  :
                                      BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        color: Colors.grey,
                                      ),
                                  height: 45,
                                  constraints: const BoxConstraints(
                                    maxWidth: 450.0,
                                  ),
                                  child: MaterialButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      onPressed: () {
                                        if(canMakeAppointment == true){
                                          //Make the appointment
                                          sendAppointmentDetails(context);
                                        }
                                        else{
                                          appointmentAlreadyMadeDialog();
                                        }
                                      },
                                      child: canMakeAppointment ?
                                      const Text(
                                        'Make Appointment',
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )
                                          :
                                      const Text(
                                        'Appointment In Progress',
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                  ),
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
            ),
    );
  }

  //Function that send the appointment details to the backend
  Future<void> sendAppointmentDetails(BuildContext context) async {

    String? accessToken = await secureStorage.read(key: 'accessToken');

    if (context.mounted) {
      if (await checkLoginStatus(context)) {
        try {
          // Obtaining the URL to a variable
          const String apiUrl = makeAppointmentEndpoint;

          //Converting the url to uri
          Uri uri = Uri.parse(apiUrl);

          Map<String, dynamic> appointmentData = {
            'quiz_result' : widget.quizResultId,
            'admin' : widget.counselorDetails['admin_id'],
          };

          //Sending the data to the backend
          final response = await http.post(
            uri,
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            },
            body: json.encode(appointmentData),
          );

          if (response.statusCode == 201) {
            print("Appointment successfull");
            appointmentSuccessDialog();
          } else {
            final data = json.decode(response.body);

            if(data.containsKey('counselor_deleted')){
              counselorNotAvailableDailog();
            }
            else {
              print('Failed to send data ${response.body}');
            }
          }
        } catch (e) {
          print('Exception occured: $e');
        }
      }
    }
  }

  //Dialog box to display the appointment is successfull
  void appointmentSuccessDialog(){
    QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        barrierDismissible: false,
        onConfirmBtnTap: (){
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
        title: 'Appointment Successfull',
        text: 'Please wait patiently. A mail will be received from the counselor within several days',
    );
  }

  //Dialog box to display the appoinment is already made
  void appointmentAlreadyMadeDialog(){
    QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        title: 'Previously Made Appointment Is Still In Progress',
      text: 'Your previously made appoinment is still in progress, please wait patiently until a mail is received.'
    );
  }

  void counselorNotAvailableDailog(){
    QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        title: 'Counselor Not Availbale',
        text: 'The Counselor is not currently available',
        onConfirmBtnTap: (){
          Navigator.of(context).pop();
          Navigator.of(context).pop();
    }
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
