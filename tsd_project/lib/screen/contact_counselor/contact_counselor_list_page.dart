import 'package:flutter/material.dart';
import 'package:tsd_project/decoration_tools/top_app_bar.dart';

class ContactCounselorList extends StatefulWidget {
  @override
  State<ContactCounselorList> createState() => _ContactCounselorListState();
}

class _ContactCounselorListState extends State<ContactCounselorList> {
  //The list that contains the counselor ids, names, and locations
  List<Map<String, dynamic>> counselorList = [
    {
      'name': 'Prasanna Gamage Kumaradasa',
      'location': 'Moratuwa, Kadanapitiya, Homagama'
    },
    {'name': 'Indika Kumarathunga', 'location': 'Narahenpita, pitipana'},
    {
      'name': 'Boyd Dias Thotawaththa',
      'location': 'Moratuwa, Katunayaka, Colombo 13'
    },
    {
      'name': 'Boyd Dias Thotawaththa',
      'location': 'Moratuwa, Katunayaka, Colombo 13'
    },
    {
      'name': 'Boyd Dias Thotawaththa',
      'location': 'Moratuwa, Katunayaka, Colombo 13'
    },
    {
      'name': 'Boyd Dias Thotawaththa',
      'location': 'Moratuwa, Katunayaka, Colombo 13'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTopAppBar(
        pageIndex: 1,
        pageName: "Contact Counselors",
      ),
      body: counselorList.isEmpty
          ? Container(
              color: Colors.white,
              child: const Padding(
                padding: EdgeInsets.all(15.0),
                child: Center(
                    child: Text(
                  "< No Available Counselors >",
                  style: TextStyle(
                      color: Color.fromRGBO(3, 71, 120, 1),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                )),
              ),
            )
          : Container(
              color: Colors.white,
              //List View
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
                          constraints: const BoxConstraints(maxWidth: 768),
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
                                  color: Color.fromRGBO(92, 94, 95, 0.71),
                                  offset: Offset(5, 2),
                                  blurRadius: 4)
                            ],
                          ),
                          //The material button inside the first main container
                          child: MaterialButton(
                            onPressed: () {
                              //Navigate to the contact counselor page with the quiz result id and the admin id
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
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
                                        child: Image.asset(
                                          "assets/images/doctor.png",
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
                                        const EdgeInsets.fromLTRB(5, 10, 0, 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            //Counselor name
                                            Expanded(
                                                child: Text(
                                              counselorList[i]['name'],
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
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
                                                        ['location'],
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Color.fromRGBO(
                                                            3, 71, 120, 1),
                                                        fontWeight:
                                                            FontWeight.bold))),
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
    );
  }
}
