// // ignore_for_file: constant_identifier_names

// import 'package:deptech_app/infrastructure/dal/daos/user/models/base_list_resp.dart';
// import 'package:flutter/material.dart';

// import '../../../services/local_storage_service.dart';
// import '../models/user_data_model.dart';
// import 'i_user_data_source.dart';

// const String TAG_INJECT_USER_LOCAL_DATA_SOURCE = 'TAG_INJECT_USER_LOCAL_DATA_SOURCE';

// class UserLocalDataSource implements IUserDataSource {
//   final LocalStorageService localStorageService;

//   UserLocalDataSource(this.localStorageService);

//   @override
//   Future<BaseListResp<UserDataModel?>?> getAllUserData() async {
//     List<Map<String, dynamic>?>? data = await localStorageService.storage.getItem(KEY_STORAGE_SERVICE_USER_LOCAL);
//     if (data == null) return null;
//     return BaseListResp.fromJson(data, UserDataModel.fromJson);
//   }

//   @override
//   Future<UserDataModel?> getUserData(int id) async {
//     try {
//       List<Map<String, dynamic>?>? data = await localStorageService.storage.getItem(KEY_STORAGE_SERVICE_USER_LOCAL);
//       var dataSelected = data?.firstWhere(
//         (element) => element?['id'] == id,
//       );
//       if (dataSelected == null) return null;
//       final result = UserDataModel.fromJson(dataSelected);
//       return result;
//     } catch (e) {
//       debugPrint('[${this}][getUserData] catch: $e');
//       return null;
//     }
//   }

//   @override
//   Future<String?> updateUserData(int id, UserDataModel? data) async {
//     try {
//       List<Map<String, dynamic>?>? dataLocal =
//           await localStorageService.storage.getItem(KEY_STORAGE_SERVICE_USER_LOCAL);
//       dataLocal?.removeWhere((element) => element?['id'] == id);
//       await localStorageService.storage.setItem(KEY_STORAGE_SERVICE_USER_LOCAL, dataLocal);
//       await insertUserData(id, data);
//       return 'update local user data with id=$id success';
//     } catch (e) {
//       debugPrint('[${this}][updateUserData] catch: $e');
//       return null;
//     }
//   }

//   @override
//   Future<int?> insertUserData(int id, UserDataModel? data) async {
//     try {
//       List<Map<String, dynamic>?>? dataLocal =
//           await localStorageService.storage.getItem(KEY_STORAGE_SERVICE_USER_LOCAL);
//       dataLocal?.add(data?.toJson());
//       await localStorageService.storage.setItem(KEY_STORAGE_SERVICE_USER_LOCAL, dataLocal);
//       return 1;
//     } catch (e) {
//       debugPrint('[${this}][insertUserData] catch: $e');
//       return null;
//     }
//   }
// }
