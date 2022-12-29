import 'package:deptech_app/infrastructure/dal/daos/note/data_sources/note_db_data_source.dart';
import 'package:deptech_app/infrastructure/dal/daos/note/models/note_model.dart';
import 'package:deptech_app/infrastructure/dal/daos/user/models/base_list_resp.dart';
import 'package:deptech_app/infrastructure/dal/services/db_service.dart';
import 'package:deptech_app/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'note_db_data_source_test.mocks.dart';

class DbServiceTest extends Mock implements DbService {}

@GenerateMocks([DbServiceTest])
void main() {
  late NoteDbDataSource noteDbDataSource;
  late MockDbServiceTest mockDbServiceTest;

  late int userId;
  late NoteModel noteModel;

  setUpAll(() {
    setupTimezone();
    mockDbServiceTest = MockDbServiceTest();
    noteDbDataSource = NoteDbDataSource(dbService: mockDbServiceTest);

    userId = 1;
    noteModel = NoteModel(
      userId: userId,
      id: 1,
      title: 'note title',
      description: 'note desc',
      datetimeTs: 833907600000,
      datetimeReminderTs: 1,
    );
  });

  group('NoteDbDataSource getNotesByUserId', () {
    test('[success]', () async {
      when(mockDbServiceTest.getList(
        fromJsonModel: NoteModel.fromJson,
        tableName: NOTE_TABLE_NAME,
        where: 'userId = ?',
        whereArgs: [userId],
      )).thenAnswer((_) async => BaseListResp<NoteModel>(data: [noteModel]));

      final result = await noteDbDataSource.getNotesByUserId(userId);

      verify(mockDbServiceTest.getList(
        fromJsonModel: NoteModel.fromJson,
        tableName: NOTE_TABLE_NAME,
        where: 'userId = ?',
        whereArgs: [userId],
      ));
      expect(result, isNotNull);
      expect(result, isA<BaseListResp<NoteModel>>());
      expect(result?.data, [noteModel]);
    });

    test('[failed]', () async {
      when(mockDbServiceTest.getList(
        fromJsonModel: NoteModel.fromJson,
        tableName: NOTE_TABLE_NAME,
        where: 'userId = ?',
        whereArgs: [userId],
      )).thenAnswer((_) async => BaseListResp<NoteModel>());

      final result = await noteDbDataSource.getNotesByUserId(userId);

      verify(mockDbServiceTest.getList(
        fromJsonModel: NoteModel.fromJson,
        tableName: NOTE_TABLE_NAME,
        where: 'userId = ?',
        whereArgs: [userId],
      ));
      expect(result, isNotNull);
      expect(result, isA<BaseListResp<NoteModel>>());
      expect(result?.data, isNull);
    });
  });

  group('NoteDbDataSource insertNote', () {
    test('[success]', () async {
      when(mockDbServiceTest.insert(
        tableName: NOTE_TABLE_NAME,
        data: noteModel.toJson(),
      )).thenAnswer((_) async => 1);

      final result = await noteDbDataSource.insertNote(noteModel);

      verify(mockDbServiceTest.insert(
        tableName: NOTE_TABLE_NAME,
        data: noteModel.toJson(),
      ));
      expect(result, isNotNull);
      expect(result, isA<int>());
      expect(result, 1);
    });

    test('[failed]', () async {
      when(mockDbServiceTest.insert(
        tableName: NOTE_TABLE_NAME,
        data: noteModel.toJson(),
      )).thenAnswer((_) async => 0);

      final result = await noteDbDataSource.insertNote(noteModel);

      verify(mockDbServiceTest.insert(
        tableName: NOTE_TABLE_NAME,
        data: noteModel.toJson(),
      ));

      expect(result, 0);
    });
  });

  group('NoteDbDataSource updateNote', () {
    test('[success]', () async {
      when(mockDbServiceTest.update(
        tableName: NOTE_TABLE_NAME,
        id: noteModel.id ?? 0,
        data: noteModel.toJson(),
      )).thenAnswer((_) async => 1);

      final result = await noteDbDataSource.updateNote(noteModel);

      verify(mockDbServiceTest.update(
        tableName: NOTE_TABLE_NAME,
        id: noteModel.id ?? 0,
        data: noteModel.toJson(),
      ));

      expect(result, isNotNull);
      expect(result, isA<String>());
    });

    test('[failed]', () async {
      when(mockDbServiceTest.update(
        tableName: NOTE_TABLE_NAME,
        id: noteModel.id ?? 0,
        data: noteModel.toJson(),
      )).thenAnswer((_) async => 0);

      final result = await noteDbDataSource.updateNote(noteModel);

      verify(mockDbServiceTest.update(
        tableName: NOTE_TABLE_NAME,
        id: noteModel.id ?? 0,
        data: noteModel.toJson(),
      ));

      expect(result, isA<String>());
    });
  });

  group('NoteDbDataSource deleteNote', () {
    test('[success]', () async {
      when(mockDbServiceTest.delete(
        tableName: NOTE_TABLE_NAME,
        id: noteModel.id,
      )).thenAnswer((_) async => 1);

      final result = await noteDbDataSource.deleteNote(noteModel.id!);

      verify(mockDbServiceTest.delete(
        tableName: NOTE_TABLE_NAME,
        id: noteModel.id,
      ));

      expect(result, isNotNull);
      expect(result, isA<int>());
      expect(result, 1);
    });

    test('[failed]', () async {
      when(mockDbServiceTest.delete(
        tableName: NOTE_TABLE_NAME,
        id: noteModel.id,
      )).thenAnswer((_) async => 0);

      final result = await noteDbDataSource.deleteNote(noteModel.id!);

      verify(mockDbServiceTest.delete(
        tableName: NOTE_TABLE_NAME,
        id: noteModel.id,
      ));

      expect(result, isNotNull);
      expect(result, isA<int>());
      expect(result, 0);
    });
  });
}
