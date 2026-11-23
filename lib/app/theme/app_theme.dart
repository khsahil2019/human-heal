import 'package:flutter/material.dart';
import 'color/appcolor.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: appColor.primaryBlue,
      scaffoldBackgroundColor: appColor.backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: appColor.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0.5,
      ),
      useMaterial3: true,
    );
  }
}
