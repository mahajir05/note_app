import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../infrastructure/navigation/routes.dart';
import 'form_utils.dart';

class BottomSheetUtils {
  static Future<T?> settings<T>({required Function() onUpdatePressed, required Function() onLogoutPressed}) {
    return Get.bottomSheet<T>(
      Container(
        padding: const EdgeInsets.all(30.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FormUtils.button(
              color: Colors.green,
              width: 80.w,
              title: "Update Profile",
              func: () {
                Get.back();
                onUpdatePressed();
              },
            ),
            SizedBox(
              height: 3.h,
            ),
            FormUtils.button(
              color: Colors.red,
              width: 80.w,
              title: "Log Out",
              func: () {
                Get.back();
                onLogoutPressed();
              },
            ),
            SizedBox(
              height: 3.h,
            ),
          ],
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
