import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsd_project/pages/patient_login_page.dart';
import 'package:jwt_decode/jwt_decode.dart';

//Function that stores the accessToken
Future<void> storeAccessToken(String accessToken) async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('accessToken', accessToken);
  print("Accesss token stored");
}

//Function that retrieves the accessToken
Future<String?> retrieveAccessToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('accessToken');
  print("Access token read successfully");
  return accessToken;
}

//Function that stores the lastUpdatedTimestamp
Future<void> storeLastUpdatedTimestamp(String lastUpdatedTimestamp) async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('lastUpdatedTimestamp', lastUpdatedTimestamp);
  print("Last updated timestamp stored");
}

//Function that retrieves the last updated timestamp
Future<String?> retrieveLastUpdatedTimestamp() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? lastUpdatedTimestamp = prefs.getString('lastUpdatedTimestamp');
  print("Last updated timestamp read successfully");
  return lastUpdatedTimestamp;
}

//The function that checks the user access token authentication everywhere
Future<bool> checkLoginStatus(BuildContext context) async {
  String? accessToken = await retrieveAccessToken();

  //Checkking if the access token is null
  if (accessToken != null) {
    //Checking if the access token is expired
    bool isTokenExpired = Jwt.isExpired(accessToken);
    if (isTokenExpired == false) {
      //The access token is valid, the patient can access the content
      print('Patient Access Token is Valid');
      return true;
    } else {
      //If the access token is expired return false and navigate to login screen
      print('Access Token is expired');
      if (context.mounted) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PatientLoginPage()));
      }
      return false;
    }
  } else {
    //If the access token is null return false and navigate to login screen
    print('Access Token is Null');
    if (context.mounted) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PatientLoginPage()));
    }
    return false;
  }
}

Future<void> signOut(BuildContext context) async {
  if (await checkLoginStatus(context)) {
    //Implement the log out scenario
    //Delete the current access token
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    print("Access Token deleted");
    //Redirecting to the login page
    if (context.mounted) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PatientLoginPage()));
    }
  }
}
