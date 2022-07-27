import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserRegistrationAPI {
  // static var authServerUrl = "http://18.236.212.60:80";
  static var authServerUrl = "http://10.0.2.2:5000";

  static var auth0ClientID = dotenv.env['auth0ClientID'];
  static var auth0Url = dotenv.env['auth0Url'];
  static var auth0OTPGrantType = dotenv.env['auth0OTPGrantType'];
  static var auth0ManagementAPI = dotenv.env['auth0ManagementAPI'];

  static signUp(email, username, password) async {
    var url = "$authServerUrl/signup";

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'username': username,
        'password': password,
      }),
    );
  }

  static Future<bool> logIn(email, password) async {
    var url = "$authServerUrl/login";
    var loggedIn = false;

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    var parseResponse = jsonDecode(response.body);

    if (!parseResponse["emailExists"] || !parseResponse["pwdAuthenticated"]) {
      return loggedIn;
    }
    loggedIn = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'terraformersAuthToken', parseResponse["terraformersAuthToken"]);
    await prefs.setString(
        'terraformersRefreshToken', parseResponse["terraformersRefreshToken"]);

    return loggedIn;
  }

  static Future<bool> sendResetOTP(email) async {
    var url = "$auth0Url/passwordless/start";
    var success = false;

    final response = await http
        .post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'client_id': auth0ClientID!,
        'connection': 'email',
        'email': email,
        'send': 'code'
      }),
    )
        .then((value) {
      success = true;
    }).catchError((err) {
      success = false;
    });

    return success;
  }

  static Future<bool> verifyResetOTP(email, otp) async {
    var url = "$auth0Url/oauth/token";
    var verified = false;

    final response = await http
        .post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'grant_type': auth0OTPGrantType!,
        'client_id': auth0ClientID!,
        'username': email,
        'otp': otp,
        'realm': 'email',
        'audience': auth0ManagementAPI!,
        'scope': 'openid profile email'
      }),
    )
        .then((value) {
      verified = true;
    }).catchError((err) {
      verified = false;
    });

    return verified;
  }

  static Future<bool> resetPassword(email, password) async {
    var url = "$authServerUrl/resetPassword";

    final response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    var parseResponse = jsonDecode(response.body);

    var success = false;
    if (parseResponse["resetSuccess"]) {
      success = true;
    }
    return success;
  }

  static Future<bool> userExists(email) async {
    var url = "$authServerUrl/userExists";

    final response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );

    var parseResponse = jsonDecode(response.body);

    var exists = false;
    if (parseResponse["userExists"]) {
      exists = true;
    }
    return exists;
  }

  static Future<bool> loggedInUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String authToken = prefs.getString("terraformersAuthToken") ?? "0";

    var url = "$authServerUrl/loggedInUser";
    final response = await http.get(Uri.parse(url), headers: <String, String>{
      'Authorization': 'Bearer $authToken',
    });

    if (response.statusCode != 204) {
      return false;
    }

    return true;
  }

  static Future<bool> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String terraformersRefreshToken =
        prefs.getString("terraformersRefreshToken") ?? "0";

    var url = "$authServerUrl/logout";
    final response = await http.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'terraformersRefreshToken': terraformersRefreshToken,
      }),
    );

    if (response.statusCode != 204) {
      return false;
    }

    prefs.setString("terraformersAuthToken", "");
    prefs.setString("terraformersRefreshToken", "");
    return true;
  }
}
