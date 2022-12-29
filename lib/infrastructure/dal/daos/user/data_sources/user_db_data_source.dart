// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

import '../../../services/db_service.dart';
import '../../../services/local_storage_service.dart';
import '../models/base_list_resp.dart';
import '../models/user_data_model.dart';
import 'i_user_data_source.dart';

const String TAG_INJECT_USER_DB_DATA_SOURCE = 'TAG_INJECT_USER_DB_DATA_SOURCE';

class UserDbDataSource implements IUserDataSource {
  final DbService dbService;
  final LocalStorageService localStorageService;

  UserDbDataSource({
    required this.dbService,
    required this.localStorageService,
  });

  @override
  Future<BaseListResp<UserDataModel>> getAllUserData() async {
    try {
      BaseListResp<UserDataModel> data = await dbService.getList(
        fromJsonModel: UserDataModel.fromJson,
        tableName: USER_TABLE_NAME,
      );
      return data;
    } catch (e) {
      debugPrint('[${this}][getAllUserData] catch: $e');
      return BaseListResp(data: []);
    }
  }

  @override
  Future<UserDataModel?> getUserData(int id) async {
    try {
      var data = await dbService.getSingle(
        tableName: USER_TABLE_NAME,
        where: 'id = ?',
        whereArgs: [id],
      );
      if (data.isEmpty) return null;
      var result = UserDataModel.fromJson(data);
      return result;
    } catch (e) {
      debugPrint('[${this}][getUserData] catch: $e');
      return null;
    }
  }

  @override
  Future<String?> updateUserData(int id, UserDataModel? data) async {
    try {
      var dataRes = await dbService.update(
        tableName: USER_TABLE_NAME,
        id: id,
        data: data?.toJson() ?? {},
      );
      return 'update success: $dataRes data changed';
    } catch (e) {
      debugPrint('[${this}][updateUserData] catch: $e');
      return null;
    }
  }

  @override
  Future<int?> insertUserData(int id, UserDataModel? data) async {
    try {
      var dataRes = await dbService.insert(
        tableName: USER_TABLE_NAME,
        data: data?.toJson() ?? {},
      );
      return dataRes;
    } catch (e) {
      debugPrint('[${this}][insertUserData] catch: $e');
      return null;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await localStorageService.storage.deleteItem(KEY_STORAGE_CHECK_SESSION_LOCAL);
      return true;
    } catch (e) {
      debugPrint('[${this}][logout] catch: $e');
      return false;
    }
  }
}
