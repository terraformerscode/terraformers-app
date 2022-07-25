import 'package:flutter/material.dart';

class TerraformersConst {
  static Color lightBlue = const Color.fromARGB(255, 54, 74, 84);
  static Color mediumBlue = const Color.fromARGB(255, 16, 38, 51);
  static Color darkBlue = const Color.fromARGB(255, 5, 28, 41);
  static Color yellow = const Color.fromARGB(255, 255, 187, 0);
  static Color white = const Color.fromARGB(255, 255, 255, 255);

  static ButtonStyle roundedButtonStyle = ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0),
              side: BorderSide(color: TerraformersConst.white))));
}
