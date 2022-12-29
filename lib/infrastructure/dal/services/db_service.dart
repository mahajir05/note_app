// ignore_for_file: non_constant_identifier_names, depend_on_referenced_packages

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../daos/user/models/base_list_resp.dart';
import '../daos/user/models/user_data_model.dart';

String USER_TABLE_NAME = 'User';
String NOTE_TABLE_NAME = 'Note';

class DbService {
  Future<Database> _initDatabase() async {
    Directory docDirectory = await getApplicationDocumentsDirectory();
    String path = join(docDirectory.path, 'deptech_app.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // create user table
        await db.execute(
            'CREATE TABLE $USER_TABLE_NAME (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, firstName TEXT, lastName TEXT, email TEXT, dobTs REAL NULL, gender TEXT NULL, password TEXT, photoProfile TEXT NULL)');
        await db.insert(
          USER_TABLE_NAME,
          UserDataModel(
            firstName: 'Admin',
            lastName: 'Deptech App',
            email: 'admin@email.com',
            password: 'admin123',
          ).toJson(),
        );

        // create note table
        await db.execute(
            'CREATE TABLE $NOTE_TABLE_NAME (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, userId INTEGER, title TEXT, description TEXT, datetimeTs REAL NULL, datetimeReminderTs REAL NULL, hourInterval INT NULL, isRemind INTEGER NULL)');
      },
    );
  }

  Future<Map<String, Object?>> getSingle({required String tableName, String? where, List<Object?>? whereArgs}) async {
    var database = await _initDatabase();
    var data = await database.query(tableName, where: where, whereArgs: whereArgs);
    if (data.isEmpty) return {};
    return data.first;
  }

  Future<BaseListResp<T>> getList<T>(
      {required Function fromJsonModel, required String tableName, String? where, List<Object?>? whereArgs}) async {
    var database = await _initDatabase();
    var data = await database.query(tableName, where: where, whereArgs: whereArgs);
    BaseListResp<T> result = BaseListResp.fromJson(data, fromJsonModel);
    return result;
  }

  Future<int> insert({required String tableName, required Map<String, Object?> data}) async {
    var database = await _initDatabase();
    int result = 0;
    if (data.isNotEmpty) {
      data.removeWhere((key, value) => value == null);
      result = await database.insert(tableName, data);
    }
    return result;
  }

  Future<int> update({required String tableName, required int id, required Map<String, Object?> data}) async {
    var database = await _initDatabase();
    int result = 0;
    if (data.isNotEmpty) {
      data.removeWhere((key, value) => key == 'id');
      result = await database.update(tableName, data, where: 'id = ?', whereArgs: [id]);
    }
    return result;
  }

  Future<int> delete({required String tableName, required int id}) async {
    var database = await _initDatabase();
    int result = await database.delete(tableName, where: 'id = ?', whereArgs: [id]);
    return result;
  }
}
