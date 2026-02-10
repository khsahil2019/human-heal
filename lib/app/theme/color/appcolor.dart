import 'package:flutter/material.dart';

class appColor {
  // Primary Theme
  // static const Color primaryColor = Color(0xFF2196F3); // Light Blue
  static const Color primaryColor = Colors.green; // Light Blue
  static const Color primaryDarkColor = Color(0xFF1976D2); // Deep Blue
  static const Color primaryBlue = Colors.green; // Deep Blue

  // Backgrounds
  static const Color backgroundColor = Colors.white; // Scaffold BG
  static const Color backgroundLight = Color(0xFFF2FAFF); // Light hospital tone

  // Text
  static const Color textColor = Color(0xFF1A1A1A); // Primary text
  static const Color textSecondary = Color(0xFF757575); // Light text
  static const Color textWhite = Colors.white;

  // Buttons
  // static const Color buttonColor = primaryDarkColor;
  static const Color buttonColor = appColor.primaryBlue;
  static const Color loaderColor = appColor.primaryBlue;
  static const Color buttonTextColor = textWhite;

  // Borders
  static const Color borderColor = Color(0xFFE0E0E0); // Light grey border

  // Icons
  // static const Color iconColor = Color(0xFF9E9E9E); // Medium grey
  static const Color iconColor = Color.fromARGB(
    255,
    92,
    200,
    96,
  ); // Medium grey

  // Status & Alerts
  static const Color errorColor = Color(0xFFD32F2F); // Red
  static const Color successColor = Color(0xFF4CAF50); // Green
  static const Color infoColor = Color(0xFF0288D1); // Cyan

  // Divider
  static const Color dividerColor = Color(0xFFBDBDBD);

  // Disabled
  static const Color disabledColor = Color(0xFFB0BEC5);

  // Shadow
  static const Color shadowColor = Color(0x29000000); // Low-opacity black

  // Custom UI States (optional)
  static const Color inputFillColor = Color(0xFFF5F5F5);
  static const Color focusColor = Color(0xFF64B5F6);
}
