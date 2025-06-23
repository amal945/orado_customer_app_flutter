import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemeData {
  static ThemeData lightMode = ThemeData(
    splashColor: Colors.white,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    brightness: Brightness.light,
    cardTheme: const CardThemeData(surfaceTintColor: Colors.white, color: Colors.white),
    fontFamily: GoogleFonts.raleway().fontFamily,
    colorScheme: const ColorScheme.light(),
    scaffoldBackgroundColor: Colors.grey.shade200,
  );
  // static ThemeData darkMode = ThemeData(
  //   splashColor: AppColors.appBlack,
  //   scaffoldBackgroundColor: Colors.black,
  //   splashFactory: NoSplash.splashFactory,
  //   highlightColor: Colors.transparent,
  //   hoverColor: Colors.transparent,
  //   brightness: Brightness.dark,
  //   colorScheme: ColorScheme.dark(
  //     background: AppColors.appBlack,
  //   ),
  //   cardTheme: CardTheme(
  //     surfaceTintColor: Colors.white,
  //     color: AppColors.appBlack,
  //   ),
  // );
}
