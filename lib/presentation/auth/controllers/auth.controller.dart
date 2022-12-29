import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/features/auth/usecases/check_session_uc.dart';
import '../../../domain/features/auth/usecases/login_uc.dart';
import '../../../infrastructure/navigation/routes.dart';

class AuthController extends GetxController {
  final LoginUc loginUc;
  final CheckSessionUc checkSessionUc;

  AuthController({required this.loginUc, required this.checkSessionUc});

  @override
  void onInit() {
    super.onInit();

    Future.delayed(const Duration(seconds: 1), () {
      checkSessionFromLocal(onHaveSession: (userId) {
        Get.offNamed(Routes.HOME, arguments: userId);
      });
    });
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  // @override
  // void onClose() {
  //   super.onClose();
  // }

  void login(
    String email,
    String password, {
    Function(int)? onSuccess,
    Function()? onFailed,
  }) async {
    final result = await loginUc(email, password);
    if (result != null) {
      debugPrint('login success with userId: $result');
      if (onSuccess != null) onSuccess(result);
    } else {
      debugPrint('login failed with userId: $result');
      if (onFailed != null) onFailed();
    }
  }

  void checkSessionFromLocal({required Function(int) onHaveSession}) async {
    var result = await checkSessionUc();
    if (result != null) {
      onHaveSession(result);
    }
  }
}
