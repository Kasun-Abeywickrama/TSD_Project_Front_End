import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tsd_project/decoration_tools/custom_loading_indicator.dart';
import 'package:tsd_project/important_tools/api_endpoints.dart';
import '../../decoration_tools/top_app_bar.dart';
import '../../important_tools/user_authentication.dart';

class AppointmentDetailsPage extends StatefulWidget{
  final Map<String, dynamic> appointmentDetails;

  AppointmentDetailsPage({super.key, required this.appointmentDetails});

  @override
  State<AppointmentDetailsPage> createState() => _AppointmentDetailsPageState();
}

class _AppointmentDetailsPageState extends State<AppointmentDetailsPage> {

  //Declaring the variable to check if the page is loading
  bool isLoading = true;

  //Initializing the flutter secure storage
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<void> setIsPatientViewedTrue(BuildContext context) async {

    String? accessToken = await secureStorage.read(key: 'accessToken');

    if (context.mounted) {
      if (await checkLoginStatus(context)) {
        try {
          // Obtaining the URL to a variable
          const String apiUrl = makeIsPatientViewedTrueEndpoint;

          //Converting the url to uri
          Uri uri = Uri.parse(apiUrl);

          Map<String, dynamic> appointmentId = {
            'appointment_id': widget.appointmentDetails['appointment_id']
          };

          final response = await http.post(
            uri,
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            },
            body: json.encode(appointmentId),
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
      if(context.mounted){
        setIsPatientViewedTrue(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTopAppBar(
      pageIndex: 1,
      pageName: "Appointment Details",
    ),
      body: isLoading
          ? CustomLoadingIndicator()
          :
        Container(
          color: Colors.white,
          child: RefreshIndicator(
            onRefresh: () => initialProcess(context),
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
                                      'Counselor Name : ',
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
                                      padding: const EdgeInsets.fromLTRB(50.0, 0, 0, 0),
                                      child: Text(
                                        '${widget.appointmentDetails['counselor_first_name']} ${widget.appointmentDetails['counselor_last_name']}',
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
                                      'Appointment Date : ',
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
                                      padding: const EdgeInsets.fromLTRB(50.0, 0, 0, 0),
                                      child: Text(
                                        widget.appointmentDetails['appointment_date'],
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
                                      'Appointment Time : ',
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
                                      padding: const EdgeInsets.fromLTRB(50.0, 0, 0, 0),
                                      child: Text(
                                        widget.appointmentDetails['appointment_time'],
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
                                      'Appointment Location : ',
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
                                      padding: const EdgeInsets.fromLTRB(50.0, 0, 0, 0),
                                      child: Text(
                                        widget.appointmentDetails['appointment_location'],
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
                                      'Additional Notes : ',
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
                                      padding: const EdgeInsets.fromLTRB(50.0, 0, 0, 0),
                                      child: Text(
                                        widget.appointmentDetails['response_description'],
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
}