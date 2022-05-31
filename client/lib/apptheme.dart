import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const fgWhite = Colors.white;
const bgNavy = Color.fromARGB(255, 16, 38, 51);
const navBtnUnselectColor = Color.fromARGB(255, 196, 222, 223);
const navBtnSelectColor = Color.fromARGB(255, 251, 215, 132);

class AppTheme {
  ThemeData buildThemeData() {
    return ThemeData.dark().copyWith(
      primaryColor: fgWhite,
      textTheme: GoogleFonts.dellaRespiraTextTheme().copyWith(
        headline1: GoogleFonts.dellaRespira().copyWith(
          fontSize: 48.0,
          color: fgWhite
        ),
        headline3: GoogleFonts.dellaRespira().copyWith(
          fontSize: 20.0,
          color: fgWhite
        ),
      ),
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
