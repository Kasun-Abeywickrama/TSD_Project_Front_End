import 'package:flutter/material.dart';
import 'package:tsd_project/decoration_tools/top_app_bar.dart';
import 'package:tsd_project/important_tools/api_endpoints.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../decoration_tools/custom_loading_indicator.dart';
import '../../important_tools/user_authentication.dart';
import 'ask_private_question_page.dart';

class AskPrivateQuestionCounselorListPage extends StatefulWidget {
  @override
  State<AskPrivateQuestionCounselorListPage> createState() =>
      _AskPrivateQuestionCounselorListPageState();
}

class _AskPrivateQuestionCounselorListPageState
    extends State<AskPrivateQuestionCounselorListPage> {
  //The list that contains the counselor ids, names, and locations
  List<CounselordetailsModel> counselorList = [];

  //Declaring the variable to check if the page is loading
  bool isLoading = true;

  //Function that gets the existing data from the database
  Future<void> setCounselorDetails(BuildContext context) async {
    //This process Fetches the data from the backend
    String? accessToken = await retrieveAccessToken();

    if (context.mounted) {
      if (await checkLoginStatus(context)) {
        try {
          // Obtaining the URL to a variable
          const String apiUrl = requestCounselorDetailsEndpoint;

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
            final Map<String, dynamic> backendCounselorDetails =
                json.decode(response.body);

            if (context.mounted) {
              //Intializing these variables and rebuild the build method
              setState(() {
                counselorList =
                    List.from(backendCounselorDetails['counselor_details'])
                        .map<CounselordetailsModel>((item) {
                  return CounselordetailsModel(
                      authUserId: item['auth_user_id'],
                      adminId: item['admin_id'],
                      email: item['email'],
                      firstName: item['first_name'],
                      lastName: item['last_name'],
                      location: item['location'],
                      mobileNumber: item['mobile_number'],
                      profileImage: item['profile_image'],
                      website: item['website']);
                }).toList();

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
        setCounselorDetails(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomTopAppBar(
          pageIndex: 1,
          pageName: "Contact Counselors",
        ),
        body: isLoading
            ? CustomLoadingIndicator()
            : (counselorList.isEmpty
                ? Container(
                    color: Colors.white,
                    child: RefreshIndicator(
                      onRefresh: () => initialProcess(context),
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
                                  "< No Available Counselors >",
                                  style: TextStyle(
                                      color: Color.fromRGBO(3, 71, 120, 1),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )),
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ))
                : Container(
                    color: Colors.white,
                    //List View
                    child: RefreshIndicator(
                      onRefresh: () => initialProcess(context),
                      child: ListView(children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          //The list generating column
                          child: Column(
                            children: List.generate(
                              counselorList.length,
                              (i) => Padding(
                                padding: const EdgeInsets.all(15.0),
                                //The main container
                                child: Container(
                                  constraints:
                                      const BoxConstraints(maxWidth: 768),
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 232, 230, 230),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                          color:
                                              Color.fromRGBO(92, 94, 95, 0.71),
                                          offset: Offset(5, 2),
                                          blurRadius: 4)
                                    ],
                                  ),
                                  //The material button inside the first main container
                                  child: MaterialButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          (MaterialPageRoute(
                                              builder: (context) =>
                                                  AskPrivateQuestionPage(
                                                    adminId: counselorList[i]
                                                        .adminId,
                                                    counselorFirstName:
                                                        counselorList[i]
                                                            .firstName,
                                                    counselorLastName:
                                                        counselorList[i]
                                                            .lastName,
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
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 10, 10, 10),
                                            child: ClipOval(
                                              child: SizedBox(
                                                height: 100,
                                                width: 100,
                                                child: Image.network(
                                                  "https://mindcare.pythonanywhere.com//media/${counselorList[i].profileImage}",
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        Flexible(
                                          flex: 65,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                5, 10, 0, 10),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    //Counselor name
                                                    Expanded(
                                                        child: Text(
                                                      "${counselorList[i].firstName} ${counselorList[i].lastName}",
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color.fromRGBO(
                                                            3, 71, 120, 1),
                                                      ),
                                                    )),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Row(
                                                  children: [
                                                    //Counselor location
                                                    Expanded(
                                                        child: Text(
                                                            counselorList[i]
                                                                .location,
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        3,
                                                                        71,
                                                                        120,
                                                                        1),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))),
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
                        ),
                      ]),
                    ),
                  )));
  }
}

class CounselordetailsModel {
  int authUserId;
  int adminId;
  String email;
  String firstName;
  String lastName;
  String location;
  String website;
  String mobileNumber;
  String profileImage;

  CounselordetailsModel({
    required this.authUserId,
    required this.adminId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.location,
    required this.website,
    required this.mobileNumber,
    required this.profileImage,
  });
}
