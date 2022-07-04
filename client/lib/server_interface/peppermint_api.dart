import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class PeppermintAPI {
  static const peppermintUrl = "https://cdn.peppermint-api.com";

  static getContracts() async {
    var url = "$peppermintUrl/api/v2/contracts/";

    final response = await http.get(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    print(response.body);
  }
}
