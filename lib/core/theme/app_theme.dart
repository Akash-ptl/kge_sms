import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const primaryColor = Color(0xFF10B981); // Emerald Green
  static const secondaryColor = Color(0xFF3B82F6); // Action Blue
  static const darkBg = Color(0xFF020617); // Extra Dark Slate
  static const surfaceDark = Color(0xFF0F172A); // Slate 800
  static const borderColor = Color(0xFF1E293B); 
  
  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBg,
    textTheme: GoogleFonts.shareTechMonoTextTheme(ThemeData.dark().textTheme),
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceDark,
      outline: borderColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBg,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5),
    ),
  );
}
