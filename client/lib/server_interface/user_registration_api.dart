import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserRegistrationAPI {
  static var serverUrl = "http://18.236.212.60:80";

  static var auth0ClientID = dotenv.env['auth0ClientID'];
  static var auth0Url = dotenv.env['auth0Url'];
  static var auth0OTPGrantType = dotenv.env['auth0OTPGrantType'];
  static var auth0ManagementAPI = dotenv.env['auth0ManagementAPI'];

  static signUp(email, username, password) async {
    var url = "$serverUrl/signup";

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

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var parseToken = jsonDecode(response.body);
    await prefs.setString(
        'terraformersAuthToken', parseToken["terraformersAuthToken"]);
  }

  static Future<bool> logIn(email, password) async {
    var url = "$serverUrl/login";
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
    var url = "$serverUrl/resetPassword";

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
    var url = "$serverUrl/userExists";

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

  // TODO: Incomplete - Check token and authenticate user
  static void checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString("terraformersAuthToken");
    if (authToken == null) return;
  }
}
