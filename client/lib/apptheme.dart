import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const bgNavy = Color.fromARGB(255, 16, 38, 51);
const navBtnUnselectColor = Color.fromARGB(255, 196, 222, 223);
const navBtnSelectColor = Color.fromARGB(255, 251, 215, 132);

class AppTheme {
  ThemeData buildThemeData() {
    return ThemeData.light().copyWith(
      primaryColor: bgNavy,
      textTheme: GoogleFonts.dellaRespiraTextTheme(),
      scaffoldBackgroundColor: bgNavy,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: bgNavy,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: bgNavy,
        unselectedItemColor: navBtnUnselectColor,
        selectedItemColor: navBtnSelectColor,
      ),
    );
  }
}
