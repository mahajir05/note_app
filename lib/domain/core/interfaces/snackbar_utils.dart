import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarUtils {
  static generalSnackbar({required String title, required String message, Color? colorText, Color? backgroundColor}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      colorText: colorText,
      backgroundColor: backgroundColor,
    );
  }
}
