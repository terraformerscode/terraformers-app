import 'package:flutter/material.dart';

class TerraformersConst {
  Color lightBlue = const Color.fromARGB(255, 54, 74, 84);
  Color mediumBlue = const Color.fromARGB(255, 16, 38, 51);
  Color darkBlue = const Color.fromARGB(255, 5, 28, 41);
  Color yellow = const Color.fromARGB(255, 255, 187, 0);
}

extension ShowSnackBar on BuildContext {
  void showSnackBar({
    required String message,
    Color backgroundColor = Colors.white,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    ));
  }

  void showErrorSnackBar({required String message}) {
    showSnackBar(message: message, backgroundColor: Colors.red);
  }
}
