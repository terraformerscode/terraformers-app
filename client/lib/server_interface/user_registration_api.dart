import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserRegistrationAPI {
  static var homeUrl = "http://10.0.2.2:5000";

  // TODO: Put in .env file
  static var auth0ClientID = 'WAokWY98Pim7IsbERw2gp8XfEbcwmTAn';
  static var auth0Url = 'https://dev-gxfk8w7z.us.auth0.com';

  static signUp(email, username, password) async {
    var url = "$homeUrl/signup";

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
    var url = "$homeUrl/login";
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

    final response = await http
        .post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'client_id': auth0ClientID,
        'connection': 'email',
        'email': email,
        'send': 'code'
      }),
    )
        .then((value) {
      print(value);
      return true;
    }).catchError((err) {
      print(err);
      return false;
    });

    return false;
  }

  // TODO: Incomplete - Check token and authenticate user
  static void checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString("terraformersAuthToken");
    if (authToken == null) return;
  }
}
