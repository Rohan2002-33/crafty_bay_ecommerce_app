import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';

class AppSnack {
  AppSnack._();

  static void success(String message) =>
      _show(message, AppColors.success, Icons.check_circle_outline);

  static void error(String message) =>
      _show(message, AppColors.danger, Icons.error_outline);

  static void _show(String message, Color color, IconData icon) {
    Get.rawSnackbar(
      message: message,
      backgroundColor: color,
      icon: Icon(icon, color: Colors.white),
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }
}