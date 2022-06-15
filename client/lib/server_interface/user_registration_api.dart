import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserRegistrationAPI {
  static signUp(email, username, password) async {
    //TODO: Change URL to server host url
    var url = "http://10.0.2.2:5000/signup";

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

    // if (response.statusCode == 201) {
    //   // If the server did return a 201 CREATED response,
    //   // then parse the JSON.

    // } else {
    //   // If the server did not return a 201 CREATED response,
    //   // then throw an exception.
    //   throw Exception('Failed to create album.');
    // }
  }
}
