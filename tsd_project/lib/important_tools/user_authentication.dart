import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:tsd_project/screen/login.dart';
import 'package:jwt_decode/jwt_decode.dart';

const FlutterSecureStorage secureStorage = FlutterSecureStorage();

//The function that checks the user token authentication everywhere
Future<bool> checkLoginStatus(BuildContext context) async {
  String? token = await secureStorage.read(key: 'token');

  //Checkking if the token is null
  if (token != null) {
    //Checking if the token is expired
    bool isTokenExpired = Jwt.isExpired(token);
    if (isTokenExpired == false) {
      //Decoding the token data to check auth user type
      try {
        final Map<String, dynamic> decodedToken = Jwt.parseJwt(token);

        final String authUserType = decodedToken['auth_user_type'];

        if (authUserType == 'user') {
          print('User Token is Valid');
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
        print("Error converting the token : $e");
      }
    } else {
      //If the token is expired return false and navigate to login screen
      print('Token is expired');
      if (context.mounted) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => login_user()));
      }
      return false;
    }
  } else {
    //If the token is null return false and navigate to login screen
    print('Token is Null');
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
    //Delete the current token
    await secureStorage.delete(key: 'token');
    print("Token deleted");
    //Redirecting to the login page
    if (context.mounted) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => login_user()));
    }
  }
}
