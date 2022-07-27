import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ExperienceDetailsAPI {
  // static var expServerUrl = "http://18.236.212.60:80"; //AWS
  static var expServerUrl = "http://10.0.2.2:6000"; //local

  static Future<dynamic>
      getExperienceDetails() async {
    var url = "$expServerUrl/experienceDetails";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      print("Erorr: FAILED TO RETRIEVE EXPERIENCE DETAILS");
      return {};
    }
    return jsonDecode(response.body);
  }

  static Future<dynamic>
      getUserCountryISO() async {
    var url = "$expServerUrl/userCountryISO";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      print("Erorr: FAILED TO RETRIEVE UserCountryISO");
      return {};
    }
    return jsonDecode(response.body);
  }
}
