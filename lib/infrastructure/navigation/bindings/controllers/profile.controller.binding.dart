import 'package:get/get.dart';

import '../../../../domain/features/user/usecases/update_user_data_uc.dart';
import '../../../../presentation/profile/controllers/profile.controller.dart';

class ProfileControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<UpdateUserDataUc>(UpdateUserDataUc(Get.find()));
    Get.lazyPut<ProfileController>(
      () => ProfileController(getUserDataUc: Get.find(), updateUserDataUc: Get.find()),
    );
  }
}
