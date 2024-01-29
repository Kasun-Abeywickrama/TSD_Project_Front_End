import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsd_project/important_tools/api_endpoints.dart';
import 'package:tsd_project/pages/patient_login_page.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

//Function that stores the accessToken
Future<void> storeAccessToken(String accessToken) async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('accessToken', accessToken);
  print("Access token stored");
}

//Function that retrieves the accessToken
Future<String?> retrieveAccessToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('accessToken');
  print("Access token read successfully");
  return accessToken;
}

//Function that stores the refreshToken
Future<void> storeRefreshToken(String refreshToken) async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('refreshToken', refreshToken);
  print("Refresh token stored");
}

//Function that retrieves the refreshToken
Future<String?> retrieveRefreshToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? refreshToken = prefs.getString('refreshToken');
  print("Refresh token read successfully");
  return refreshToken;
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
  final SharedPreferences prefs = await SharedPreferences.getInstance();
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
        if(await blacklistRefreshToken(context)) {
          await prefs.remove('accessToken');
          await prefs.remove('refreshToken');
          if(context.mounted) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PatientLoginPage()));
          }
        }
        else{
          print("refresh token blacklisting failed");
        }
      }
      return false;
    }
  } else {
    //If the access token is null return false and navigate to login screen
    print('Access Token is Null');
    if (context.mounted) {
      if(await blacklistRefreshToken(context)) {
        await prefs.remove('refreshToken');
        if (context.mounted) {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PatientLoginPage()));
        }
      }
      else{
        print("refresh token blacklisting failed");
      }
    }
    return false;
  }
}

Future<void> signOut(BuildContext context) async {
  if (await checkLoginStatus(context)) {
    //Implement the log out scenario
    //Delete the current access token
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(context.mounted) {
      if (await blacklistRefreshToken(context)) {
        await prefs.remove('accessToken');
        await prefs.remove('refreshToken');
        print("signed out");
        if (context.mounted) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => PatientLoginPage()));
        }
      }
      else{
        print("refresh token blacklisting failed");
      }
    }
  }
}

Future<bool> blacklistRefreshToken(BuildContext context) async{

  try {
    final String? refreshToken = await retrieveRefreshToken();

    if(refreshToken != null) {
      // Obtaining the URL to a variable
      const String apiUrl = blacklistRefreshTokenEndpoint;

      //Converting the url to uri
      Uri uri = Uri.parse(apiUrl);

      Map<String, dynamic> formData = {
        'refresh_token': refreshToken,
      };

      //Requesting the data from the backend
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(formData),
      );

      if (response.statusCode == 201) {
        print("refresh token blacklisted");
        return true;

      } else {
        print('refresh token expired or any other error');
        return true;
      }
    }
    else{
      print("refresh token is null");
      if (context.mounted) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PatientLoginPage()));
      }
      return false;
    }
  } catch (e) {
    print('Exception occured: $e');
    return false;
  }
}
