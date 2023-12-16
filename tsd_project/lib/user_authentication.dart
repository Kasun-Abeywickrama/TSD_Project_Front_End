import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:tsd_project/screen/login.dart';
import 'package:jwt_decode/jwt_decode.dart';

const FlutterSecureStorage secureStorage = FlutterSecureStorage();

//This function will check if the token is null, and if it is null, then redirects to the login page
Future<void> checkLoginStatus(BuildContext context) async {
  String? token = await secureStorage.read(key: 'token');

  //Checkking if the token is null
  if (token != null) {
    //Checking if the token is expired
    bool isTokenExpired = Jwt.isExpired(token);
    if (isTokenExpired == false) {
      //Decoding the token data to check auth user type
      try {
        final Map<String, dynamic> decodedToken = Jwt.parseJwt(token);

        final String auth_user_type = decodedToken['auth_user_type'];

        if (auth_user_type == 'user') {
          print('User is logged in');
        } else {
          print('You does not have access to this content');
          if (context.mounted) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => login_user()));
          }
        }
      } catch (e) {
        print("Error converting the token : $e");
      }
    } else {
      print('Token is expired');
      if (context.mounted) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => login_user()));
      }
    }
  } else {
    print('user is not logged in');
    if (context.mounted) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => login_user()));
    }
  }
}

class JwtDecoder {}
