import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:tsd_project/screen/login.dart';
import 'package:jwt_decode/jwt_decode.dart';

const FlutterSecureStorage secureStorage = FlutterSecureStorage();

//The function that checks the user access token authentication everywhere
Future<bool> checkLoginStatus(BuildContext context) async {
  String? accessToken = await secureStorage.read(key: 'accessToken');

  //Checkking if the access token is null
  if (accessToken != null) {
    //Checking if the access token is expired
    bool isTokenExpired = Jwt.isExpired(accessToken);
    if (isTokenExpired == false) {
      //Decoding the access token data to check auth user type
      try {
        final Map<String, dynamic> decodedAccessToken =
            Jwt.parseJwt(accessToken);

        final String authUserType = decodedAccessToken['auth_user_type'];

        if (authUserType == 'user') {
          print('User Access Token is Valid');
          return true;
        } else {
          //If the user is not a user return false and navigate to login screen
          print('You does not have access to this content');
          if (context.mounted) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => login_user()));
          }
          return false;
        }
      } catch (e) {
        print("Error converting the access token : $e");
      }
    } else {
      //If the access token is expired return false and navigate to login screen
      print('Access Token is expired');
      if (context.mounted) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => login_user()));
      }
      return false;
    }
  } else {
    //If the access token is null return false and navigate to login screen
    print('Access Token is Null');
    if (context.mounted) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => login_user()));
    }
    return false;
  }
  return false;
}

Future<void> signOut(BuildContext context) async {
  if (await checkLoginStatus(context)) {
    //Implement the log out scenario
    //Delete the current access token
    await secureStorage.delete(key: 'accessToken');
    print("Access Token deleted");
    //Redirecting to the login page
    if (context.mounted) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => login_user()));
    }
  }
}
