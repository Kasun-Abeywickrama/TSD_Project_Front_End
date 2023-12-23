import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:tsd_project/screen/home_screen.dart';
import 'package:tsd_project/screen/login.dart';
import 'package:jwt_decode/jwt_decode.dart';

const FlutterSecureStorage secureStorage = FlutterSecureStorage();

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
          print('User is logged in');
          return true;
        } else {
          print('You does not have access to this content');
        }
      } catch (e) {
        print("Error converting the token : $e");
      }
    } else {
      print('Token is expired');
    }
  } else {
    print('user is not logged in');
  }

  if (context.mounted) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => login_user()));
  }

  return false;
}

Future<void> checkWelcomeScreenLoginStatus(BuildContext context) async {
  if (context.mounted) {
    String? token = await secureStorage.read(key: 'token');

    //Checking if the token is null
    if (token != null) {
      //Checking if the token is expired
      bool isTokenExpired = Jwt.isExpired(token);
      if (isTokenExpired == false) {
        //Decoding the token data to check auth user type
        try {
          final Map<String, dynamic> decodedToken = Jwt.parseJwt(token);

          final String auth_user_type = decodedToken['auth_user_type'];

          if (auth_user_type == 'user') {
            if (context.mounted) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            }
          } else {
            print('You does not have access to this content');
            if (context.mounted) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => login_user()));
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
}

Future<void> signOut(BuildContext context) async {
  if (context.mounted) {
    String? token = await secureStorage.read(key: 'token');

    //Checking if the token is null
    if (token != null) {
      //Checking if the token is expired
      bool isTokenExpired = Jwt.isExpired(token);
      if (isTokenExpired == false) {
        //Decoding the token data to check auth user type
        try {
          final Map<String, dynamic> decodedToken = Jwt.parseJwt(token);

          final String auth_user_type = decodedToken['auth_user_type'];

          if (auth_user_type == 'user') {
            //Implement the log out scenario
            //Delete the current token
            await secureStorage.delete(key: 'token');
            print("Token deleted");
            //Redirecting to the login page
            if (context.mounted) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => login_user()));
            }
          } else {
            print('You does not have access to this content');
            if (context.mounted) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => login_user()));
            }
          }
        } catch (e) {
          print("Error converting the token : $e");
        }
      } else {
        print('Token is expired');
        if (context.mounted) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => login_user()));
        }
      }
    } else {
      print('user is not logged in');
      if (context.mounted) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => login_user()));
      }
    }
  }
}
