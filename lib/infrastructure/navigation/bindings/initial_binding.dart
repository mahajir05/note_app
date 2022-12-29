import 'package:get/get.dart';
import 'package:localstorage/localstorage.dart';

import '../../dal/services/db_service.dart';
import '../../dal/services/local_storage_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DbService>(DbService());
    Get.put<LocalStorage>(LocalStorage(KEY_STORAGE_SERVICE_USER_LOCAL));
    Get.put<LocalStorageService>(LocalStorageService(Get.find()));
  }
}
