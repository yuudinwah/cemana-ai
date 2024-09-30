import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CemanaColors {
  static const Color primaryColor = Color(0xFF112745);
  static const Color accentColor = Color(0xFF081423);
  static const Color backgroundColor = Color(0xFFd1d8e1);
  static const Color hoverColor = Color(0xFFb2becd);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSwatch()
          .copyWith(secondary: accentColor, surface: backgroundColor),
      scaffoldBackgroundColor: backgroundColor,
      textTheme: GoogleFonts.latoTextTheme(),
      buttonTheme: ButtonThemeData(
        buttonColor: primaryColor,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
