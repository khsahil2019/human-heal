import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:human_heal/app/theme/color/appcolor.dart';

class CustomSnackbar {
  static void show({
    required String title,
    required String message,
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.rawSnackbar(
      titleText: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? Colors.redAccent : appColor.primaryColor,
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
      duration: duration,
      animationDuration: const Duration(milliseconds: 300),
      overlayBlur: 0.0,
      snackStyle: SnackStyle.FLOATING,
    );
  }
}
