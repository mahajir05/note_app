import 'package:deptech_app/domain/features/auth/usecases/login_uc.dart';
import 'package:get/get.dart';

import '../../../../domain/features/auth/repositories/i_auth_repository.dart';
import '../../../../domain/features/auth/usecases/check_session_uc.dart';
import '../../../../presentation/auth/controllers/auth.controller.dart';
import '../../../dal/daos/auth/data_sources/auth_db_source.dart';
import '../../../dal/daos/auth/data_sources/i_auth_data_source.dart';
import '../../../dal/daos/auth/repositories/auth_repository.dart';

class AuthControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<IAuthDataSource>(AuthDbSource(dbService: Get.find(), localStorageService: Get.find()));
    Get.put<IAuthRepository>(AuthRepository(dataSource: Get.find()));

    Get.put<CheckSessionUc>(CheckSessionUc(Get.find()));
    Get.put<LoginUc>(LoginUc(Get.find()));

    Get.put<AuthController>(
      AuthController(loginUc: Get.find(), checkSessionUc: Get.find()),
    );
  }
}
