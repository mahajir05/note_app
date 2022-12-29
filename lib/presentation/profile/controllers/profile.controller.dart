import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart';

import '../../../domain/features/user/entities/user_data_entity.dart';
import '../../../domain/features/user/usecases/get_user_data_uc.dart';
import '../../../domain/features/user/usecases/update_user_data_uc.dart';
import '../../../infrastructure/dal/daos/user/models/user_data_model.dart';
import '../../home/controllers/home.controller.dart';

class ProfileController extends GetxController {
  final GetUserDataUc getUserDataUc;
  final UpdateUserDataUc updateUserDataUc;
  ProfileController({required this.getUserDataUc, required this.updateUserDataUc});

  Rx<UserDataEntity?> userData = Rxn<UserDataEntity>();

  Rx<String?> photoProfileSelected = Rxn<String>();
  Rx<String?> gender = Rxn<String>();
  Rx<int?> dobTs = Rxn<int>();

  @override
  void onInit() {
    super.onInit();
    int? userId = Get.arguments as int?;
    if (userId != null) {
      getUserData(userId);
    }
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  // @override
  // void onClose() {
  //   super.onClose();
  // }

  void getUserData(
    int id, {
    Function()? onSuccess,
    Function()? onFailed,
  }) async {
    final result = await getUserDataUc(id);
    if (result != null) {
      debugPrint('getUserData success with userId: ${result.id}, email: ${result.email}');
      userData.value = result;
      photoProfileSelected.value = result.photoProfile;
      gender.value = result.gender;
      dobTs.value = result.dob?.millisecondsSinceEpoch;
      if (onSuccess != null) onSuccess();
    } else {
      debugPrint('getUserData failed with userId: $id');
      if (onFailed != null) onFailed();
    }
  }

  void updateUser({
    String? firstName,
    String? lastName,
    // int? dobTs,
    // String? gender,
    // String? photoProfile,
    required Function() onSuccess,
    required Function() onFailed,
  }) async {
    var userDataEdit = UserDataEntity(
      firstName: firstName != null && firstName.isNotEmpty && firstName != userData.value?.firstName
          ? firstName
          : userData.value?.firstName,
      lastName: lastName != null && lastName.isNotEmpty && lastName != userData.value?.lastName
          ? lastName
          : userData.value?.lastName,
      email: userData.value?.email,
      dob: dobTs.value != null
          ? dobTs.value != userData.value?.dob?.millisecondsSinceEpoch
              ? TZDateTime.fromMillisecondsSinceEpoch(local, dobTs.value!)
              : userData.value?.dob
          : null,
      gender: gender.value != userData.value?.gender ? gender.value : userData.value?.gender,
      password: userData.value?.password,
      photoProfile: photoProfileSelected.value != userData.value?.photoProfile
          ? photoProfileSelected.value
          : userData.value?.photoProfile,
    );

    final result = await updateUserDataUc(userData.value!.id!, userDataEdit);
    if (result != null) {
      debugPrint('update user data: $result');
      HomeController.instance.getUserData(userData.value!.id!);
      onSuccess();
    } else {
      onFailed();
    }
  }
}
