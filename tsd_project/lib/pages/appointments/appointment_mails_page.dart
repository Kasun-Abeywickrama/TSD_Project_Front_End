import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tsd_project/decoration_tools/custom_loading_indicator.dart';
import 'package:tsd_project/important_tools/api_endpoints.dart';
import 'package:tsd_project/pages/appointments/appointment_details_page.dart';
import '../../important_tools/user_authentication.dart';

//Appointment mail box page
class AppointmentMailsPage extends StatefulWidget {
  //When a new unique key is passed, the widget page will rebuild including the initial process method
  const AppointmentMailsPage({Key? key}) : super(key: key);

  @override
  State<AppointmentMailsPage> createState() => _AppointmentMailsPageState();
}

class _AppointmentMailsPageState extends State<AppointmentMailsPage> {
  //This is for the latest date filters
  bool latestDate = true;

  //Declaring the variable to check if the page is loading
  bool isLoading = true;

  //Sample list of appointments
  List<AppointmentListModel> appointmentList = [];

  //Function that gets the existing data from the database
  Future<void> setAppointmentList(BuildContext context) async {
    //This process Fetches the data from the backend

    if (context.mounted) {
      if (await checkLoginStatus(context)) {
        try {
          String? accessToken = await retrieveAccessToken();

          // Obtaining the URL to a variable
          String apiUrl = (await ReadApiEndpoints.readApiEndpointsData())["requestAppointmentListEndpoint"];

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
            final Map<String, dynamic> backendAppointmentList =
                json.decode(response.body);

            if (context.mounted) {
              //Intializing these variables and rebuild the build method
              setState(() {
                appointmentList =
                    List.from(backendAppointmentList['appointment_list'])
                        .map<AppointmentListModel>((item) {
                  return AppointmentListModel(
                    appointmentId: item['appointment_id'],
                    appointmentDate: item['appointment_date'],
                    appointmentTime: item['appointment_time'],
                    counselorFirstName: item['counselor_first_name'],
                    counselorLastName: item['counselor_last_name'],
                    appointmentLocation: item['appointment_location'],
                    responseDescription: item['response_description'],
                    isPatientViewed: item['is_patient_viewed'],
                    profileImage: item['profile_image'],
                  );
                }).toList();

                appointmentList = List.from(appointmentList.reversed);

                //Considering the page is loaded
                isLoading = false;

                //Considering latest date is true
                latestDate = true;
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
        setAppointmentList(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 260) {
      screenWidth = 260;
    }
    return isLoading
        ? CustomLoadingIndicator()
        : (appointmentList.isEmpty
            ? Container(
                color: Colors.white,
                child: const CustomScrollView(slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              child: Text(
                            "< No Appointment Mails >",
                            style: TextStyle(
                                color: Color.fromRGBO(3, 71, 120, 1),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          )),
                        ],
                      ),
                    ),
                  ),
                ]))
            : ListView(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: screenWidth,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Center(
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 768),
                            child: Column(
                              children: [
                                //First child is the latest and oldest buttons
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    children: [
                                      latestDate == true
                                          ? Container(
                                              constraints: const BoxConstraints(
                                                  maxHeight: 40),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  gradient:
                                                      const LinearGradient(
                                                    colors: [
                                                      Color(0xff66bef4),
                                                      Color(0xff2a58e5)
                                                    ],
                                                    stops: [0.25, 0.6],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  )),
                                              child: MaterialButton(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  onPressed: () {},
                                                  child: const Text(
                                                    "Latest",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )),
                                            )
                                          : Container(
                                              constraints: const BoxConstraints(
                                                  maxHeight: 40),
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    255, 212, 211, 211),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: MaterialButton(
                                                  onPressed: () {
                                                    if (context.mounted) {
                                                      setState(() {
                                                        appointmentList =
                                                            List.from(
                                                                appointmentList
                                                                    .reversed);
                                                        latestDate = true;
                                                      });
                                                    }
                                                  },
                                                  child: const Text(
                                                    "Latest",
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            3, 71, 120, 1),
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                            ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      latestDate == false
                                          ? Container(
                                              constraints: const BoxConstraints(
                                                  maxHeight: 40),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  gradient:
                                                      const LinearGradient(
                                                    colors: [
                                                      Color(0xff66bef4),
                                                      Color(0xff2a58e5)
                                                    ],
                                                    stops: [0.25, 0.6],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  )),
                                              child: MaterialButton(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  onPressed: () {},
                                                  child: const Text("Oldest",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight
                                                              .bold))),
                                            )
                                          : Container(
                                              constraints: const BoxConstraints(
                                                  maxHeight: 40),
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    255, 212, 211, 211),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: MaterialButton(
                                                  onPressed: () {
                                                    if (context.mounted) {
                                                      setState(() {
                                                        appointmentList =
                                                            List.from(
                                                                appointmentList
                                                                    .reversed);
                                                        latestDate = false;
                                                      });
                                                    }
                                                  },
                                                  child: const Text(
                                                    "Oldest",
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            3, 71, 120, 1),
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                            ),
                                    ],
                                  ),
                                ),
                                //The second child is the list generating column
                                Column(
                                  children: List.generate(
                                    appointmentList.length,
                                    (i) => Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      //The main container
                                      child: Container(
                                        //If the appointment mail is not viewed highlight it
                                        decoration: appointmentList[i]
                                                    .isPatientViewed ==
                                                0
                                            ? BoxDecoration(
                                                color: const Color.fromARGB(
                                                    255, 232, 230, 230),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(15),
                                                  topRight: Radius.circular(15),
                                                  bottomLeft:
                                                      Radius.circular(15),
                                                  bottomRight:
                                                      Radius.circular(15),
                                                ),
                                                border: Border.all(
                                                  color: Colors.blueAccent,
                                                  width: 5.0,
                                                ),
                                                boxShadow: const [
                                                  BoxShadow(
                                                      color: Color.fromRGBO(
                                                          92, 94, 95, 0.71),
                                                      offset: Offset(5, 2),
                                                      blurRadius: 4)
                                                ],
                                              )
                                            : const BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 232, 230, 230),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(15),
                                                  topRight: Radius.circular(15),
                                                  bottomLeft:
                                                      Radius.circular(15),
                                                  bottomRight:
                                                      Radius.circular(15),
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Color.fromRGBO(
                                                          92, 94, 95, 0.71),
                                                      offset: Offset(5, 2),
                                                      blurRadius: 4)
                                                ],
                                              ),
                                        //The material button inside the first main container
                                        child: MaterialButton(
                                          onPressed: () {
                                            //Navigate to the appointment details page
                                            Map<String, dynamic>
                                                appointmentDetailsMap = {
                                              'appointment_id':
                                                  appointmentList[i]
                                                      .appointmentId,
                                              'counselor_first_name':
                                                  appointmentList[i]
                                                      .counselorFirstName,
                                              'counselor_last_name':
                                                  appointmentList[i]
                                                      .counselorLastName,
                                              'appointment_date':
                                                  appointmentList[i]
                                                      .appointmentDate,
                                              'appointment_time':
                                                  appointmentList[i]
                                                      .appointmentTime,
                                              'appointment_location':
                                                  appointmentList[i]
                                                      .appointmentLocation,
                                              'response_description':
                                                  appointmentList[i]
                                                      .responseDescription,
                                              'profile_image':
                                                  appointmentList[i]
                                                      .profileImage,
                                            };
                                            Navigator.push(
                                                context,
                                                (MaterialPageRoute(
                                                    builder: (context) =>
                                                        AppointmentDetailsPage(
                                                          appointmentDetails:
                                                              appointmentDetailsMap,
                                                        ))));
                                          },
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Row(
                                            children: [
                                              //Counselor image
                                              Flexible(
                                                flex: 35,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 10, 10, 10),
                                                  child: ClipOval(
                                                    child: SizedBox(
                                                      height: 80,
                                                      width: 80,
                                                      child: Image.network(
                                                        "https://mindcare.pythonanywhere.com//media/${appointmentList[i].profileImage}",
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              Flexible(
                                                flex: 65,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          5, 10, 0, 10),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          //The text "Name : "
                                                          const Text(
                                                            "Name :  ",
                                                            style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      3,
                                                                      71,
                                                                      120,
                                                                      1),
                                                            ),
                                                          ),
                                                          //Counselor name
                                                          Expanded(
                                                            child: Text(
                                                              "${appointmentList[i].counselorFirstName} ${appointmentList[i].counselorLastName}",
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        3,
                                                                        71,
                                                                        120,
                                                                        1),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          //The text "Date : "
                                                          const Text(
                                                            "Date  :  ",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      3,
                                                                      71,
                                                                      120,
                                                                      1),
                                                            ),
                                                          ),
                                                          //Appointemt date
                                                          Expanded(
                                                            child: Text(
                                                              appointmentList[i]
                                                                  .appointmentDate,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        3,
                                                                        71,
                                                                        120,
                                                                        1),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          //The text "Time : "
                                                          const Text(
                                                            "Time :  ",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      3,
                                                                      71,
                                                                      120,
                                                                      1),
                                                            ),
                                                          ),
                                                          //Appointemet time
                                                          Expanded(
                                                            child: Text(
                                                              appointmentList[i]
                                                                  .appointmentTime,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        3,
                                                                        71,
                                                                        120,
                                                                        1),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ));
  }
}

//The model that stores the appointment details list
class AppointmentListModel {
  int appointmentId;
  String appointmentDate;
  String appointmentTime;
  String counselorFirstName;
  String counselorLastName;
  String appointmentLocation;
  int isPatientViewed;
  String responseDescription;
  String profileImage;

  AppointmentListModel({
    required this.appointmentId,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.counselorFirstName,
    required this.counselorLastName,
    required this.appointmentLocation,
    required this.responseDescription,
    required this.isPatientViewed,
    required this.profileImage,
  });
}
