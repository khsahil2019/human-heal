import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Safe wrapper for Get.snackbar that handles missing Overlay/Navigator gracefully.
/// Prevents "No Overlay widget found" crashes which occur when snackbar is shown
/// from async callbacks after route transitions.
void safeSnackbar(
  String title,
  String message, {
  SnackPosition snackPosition = SnackPosition.BOTTOM,
  Color? backgroundColor,
  Color? colorText,
  Duration? duration,
}) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    try {
      if (Get.context == null) return;
      Get.snackbar(
        title,
        message,
        snackPosition: snackPosition,
        backgroundColor: backgroundColor,
        colorText: colorText,
        duration: duration ?? const Duration(seconds: 3),
      );
    } catch (e) {
      // Silently ignore overlay errors in background async contexts
      debugPrint('[SnackbarHelper] Could not show snackbar: $e');
    }
  });
}
