import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const fgWhite = Colors.white;
const bgNavy = Color.fromARGB(255, 16, 38, 51);
const navBtnUnselectColor = Color.fromARGB(255, 196, 222, 223);
const navBtnSelectColor = Color.fromARGB(255, 251, 215, 132);
const elevBtnBorder = Color.fromARGB(255, 196, 222, 223);

class AppTheme {
  ThemeData buildThemeData() {
    return ThemeData.dark().copyWith(
      primaryColor: fgWhite,
      textTheme: GoogleFonts.dellaRespiraTextTheme().copyWith(
        // Use 2021 set
        displayLarge:
          GoogleFonts.dellaRespira().copyWith(color: fgWhite),
        displayMedium:
          GoogleFonts.dellaRespira().copyWith(color: fgWhite),
        displaySmall:
          GoogleFonts.dellaRespira().copyWith(color: fgWhite),
        headlineLarge:
          GoogleFonts.dellaRespira().copyWith(color: fgWhite),
        headlineMedium:
          GoogleFonts.dellaRespira().copyWith(color: fgWhite),
        headlineSmall:
          GoogleFonts.dellaRespira().copyWith(color: fgWhite), 
        titleLarge:
          GoogleFonts.dellaRespira().copyWith(color: fgWhite),
        titleMedium:
          GoogleFonts.dellaRespira().copyWith(color: fgWhite),
        titleSmall:
          GoogleFonts.dellaRespira().copyWith(color: fgWhite),
        bodyLarge:
          GoogleFonts.dellaRespira().copyWith(color: fgWhite),
        bodyMedium:
          GoogleFonts.dellaRespira().copyWith(color: fgWhite),
        bodySmall:
          GoogleFonts.dellaRespira().copyWith(color: fgWhite), 
        labelLarge:
          GoogleFonts.dellaRespira().copyWith(color: fgWhite),
        labelMedium:
          GoogleFonts.dellaRespira().copyWith(color: fgWhite),
        labelSmall:
          GoogleFonts.dellaRespira().copyWith(color: fgWhite),
      ),
      scaffoldBackgroundColor: bgNavy,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: bgNavy,
          side: const BorderSide(
            width: 0.5,
            color: elevBtnBorder,
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        // backgroundColor: bgNavy,
        unselectedItemColor: navBtnUnselectColor,
        selectedItemColor: navBtnSelectColor,
      ),
    );
  }
}
