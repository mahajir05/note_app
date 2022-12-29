import 'package:flutter/material.dart';

import '../../../services/db_service.dart';
import '../../user/models/base_list_resp.dart';
import '../models/note_model.dart';

abstract class INoteDbDataSource {
  Future<BaseListResp<NoteModel>?> getNotesByUserId(int userId);
  Future<NoteModel?> getNoteById(int noteId);
  Future<int?> insertNote(NoteModel? data);
  Future<String?> updateNote(NoteModel? data);
  Future<int?> deleteNote(int id);
}

class NoteDbDataSource implements INoteDbDataSource {
  final DbService dbService;

  NoteDbDataSource({required this.dbService});

  @override
  Future<BaseListResp<NoteModel>?> getNotesByUserId(int userId) async {
    try {
      BaseListResp<NoteModel> data = await dbService.getList(
        fromJsonModel: NoteModel.fromJson,
        tableName: NOTE_TABLE_NAME,
        where: 'userId = ?',
        whereArgs: [userId],
      );
      return data;
    } catch (e) {
      debugPrint('[${this}][getNotesByUserId] catch: $e');
      return BaseListResp();
    }
  }

  @override
  Future<NoteModel?> getNoteById(int noteId) async {
    try {
      var data = await dbService.getSingle(
        tableName: NOTE_TABLE_NAME,
        where: 'id = ?',
        whereArgs: [noteId],
      );
      if (data.isEmpty) return null;
      NoteModel dt = NoteModel.fromJson(data);
      return dt;
    } catch (e) {
      debugPrint('[${this}][getNoteById] catch: $e');
      return null;
    }
  }

  @override
  Future<int?> insertNote(NoteModel? data) async {
    try {
      var dataRes = await dbService.insert(
        tableName: NOTE_TABLE_NAME,
        data: data?.toJson() ?? {},
      );
      return dataRes;
    } catch (e) {
      debugPrint('[${this}][insertNote] catch: $e');
      return null;
    }
  }

  @override
  Future<String?> updateNote(NoteModel? data) async {
    try {
      var dataRes = await dbService.update(
        tableName: NOTE_TABLE_NAME,
        id: data?.id ?? 0,
        data: data?.toJson() ?? {},
      );
      return 'update success: $dataRes data changed';
    } catch (e) {
      debugPrint('[${this}][updateNote] catch: $e');
      return null;
    }
  }

  @override
  Future<int?> deleteNote(int id) async {
    try {
      var dataRes = await dbService.delete(
        tableName: NOTE_TABLE_NAME,
        id: id,
      );
      return dataRes;
    } catch (e) {
      debugPrint('[${this}][deleteNote] catch: $e');
      return null;
    }
  }
}
