import 'dart:math';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tsd_project/important_tools/api_endpoints.dart';
import '../important_tools/user_authentication.dart';

class CustomTopAppBar extends StatefulWidget implements PreferredSizeWidget {
  //Navigating function to go to appointment mails page
  final Function()? navigateToAppointmentMails;

  final int pageIndex;
  final String pageName;

  //Main pages index = 0
  //Back button displaying pages index = 1
  //Quiz page index = 2

  CustomTopAppBar(
      {Key? key,
      this.pageIndex = 0,
      this.pageName = "Home",
      this.navigateToAppointmentMails})
      : super(key: key);

  @override
  State<CustomTopAppBar> createState() => _CustomTopAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomTopAppBarState extends State<CustomTopAppBar> {
  String notificationAmount = "0";

  Future<void> setNotificationAmount(BuildContext context) async {
    print("notification process executed");
    //This process Fetches the data from the backend

    if (context.mounted) {
      if (await checkLoginStatus(context)) {
        try {
          String? accessToken = await retrieveAccessToken();

          // Obtaining the URL to a variable
          String apiUrl = (await ReadApiEndpoints.readApiEndpointsData())["requestNotificationAmountEndpoint"] ;

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
            final Map<String, dynamic> backendNotificationAmount =
                json.decode(response.body);

            if (context.mounted) {
              setState(() {
                notificationAmount =
                    backendNotificationAmount['notification_amount'];
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
        setNotificationAmount(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //Defining the icon widget
    Widget topIcon;

    //Assigning the icon widget
    if (widget.pageIndex == 1) {
      topIcon = GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_outlined,
            color: Colors.white,
            size: 35,
          ));
    } else if (widget.pageIndex == 2) {
      topIcon = GestureDetector(
          onTap: () {
            quitOptionDialog();
          },
          child: Transform.rotate(
            angle: pi,
            child: const Icon(
              Icons.exit_to_app_rounded,
              color: Colors.white,
              size: 35,
            ),
          ));
    } else {
      if (widget.pageName == "Home") {
        topIcon = const Icon(
          Icons.home,
          color: Colors.white,
          size: 35,
        );
      } else if (widget.pageName == "Appointment Mails") {
        topIcon = const Icon(
          Icons.mail,
          color: Colors.white,
          size: 35,
        );
      } else if (widget.pageName == "My Account") {
        topIcon = const Icon(
          Icons.account_circle,
          color: Colors.white,
          size: 35,
        );
      } else {
        topIcon = const Icon(
          Icons.quiz_rounded,
          color: Colors.white,
          size: 35,
        );
      }
    }

    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Color(0xff2a58e5),
            Color(0xff66bef4),
            Color(0xff2a58e5),
          ],
          stops: [0.25, 0.5, 0.8],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        )),
      ),
      title: Text(
        widget.pageName,
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.white, fontSize: 22),
      ),
      leading: Container(
          padding: const EdgeInsets.only(left: 20.0),
          width: double.infinity,
          child: topIcon),
      actions: [
        widget.pageIndex == 0
            ? Stack(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      size: 40.0,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (widget.navigateToAppointmentMails != null) {
                        widget.navigateToAppointmentMails!();
                      }
                    },
                  ),
                  notificationAmount != "0"
                      ? Positioned(
                          right: 5.0,
                          top: 5.0,
                          child: CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 11.0,
                              child: Text(
                                notificationAmount,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                ),
                              )),
                        )
                      : Positioned(
                          right: 5.0,
                          top: 5.0,
                          child: Container(),
                        )
                ],
              )
            : Container()
      ],
    );
  }

  //Creating the dialog box to confirm that the user wants to quit
  void quitOptionDialog() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        title: 'Do You Want To Quit ?',
        text: 'Any of the selected answers will not be saved !',
        confirmBtnText: 'Quit',
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });
  }
}
