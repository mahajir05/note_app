import 'dart:math';

import 'package:deptech_app/infrastructure/dal/daos/note/data_sources/note_db_data_source.dart';
import 'package:deptech_app/infrastructure/dal/daos/note/models/note_model.dart';
import 'package:deptech_app/infrastructure/dal/daos/note/repositories/note_repository.dart';
import 'package:deptech_app/infrastructure/dal/daos/user/models/base_list_resp.dart';
import 'package:deptech_app/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'note_repository_test.mocks.dart';

class NoteDbDataSourceTest extends Mock implements INoteDbDataSource {}

@GenerateMocks([NoteDbDataSourceTest])
void main() {
  late NoteRepository noteRepository;
  late MockNoteDbDataSourceTest mockNoteDbDataSourceTest;

  late int userId;
  late NoteModel noteModel;

  setUpAll(() {
    setupTimezone();
    mockNoteDbDataSourceTest = MockNoteDbDataSourceTest();
    noteRepository = NoteRepository(dbDataSource: mockNoteDbDataSourceTest);

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

  group('NoteRepository getNotesByUserId', () {
    test('[success]', () async {
      when(mockNoteDbDataSourceTest.getNotesByUserId(any))
          .thenAnswer((_) async => BaseListResp<NoteModel>(data: [noteModel]));

      final result = await noteRepository.getNotesByUserId(userId);

      verify(mockNoteDbDataSourceTest.getNotesByUserId(any));
      expect(result, isNotNull);
      expect(result, [noteModel]);
    });

    test('[failed]', () async {
      when(mockNoteDbDataSourceTest.getNotesByUserId(any)).thenAnswer((_) async => BaseListResp<NoteModel>(data: null));

      final result = await noteRepository.getNotesByUserId(userId);

      verify(mockNoteDbDataSourceTest.getNotesByUserId(any));
      expect(result, isNull);
    });
  });

  group('NoteRepository insertNote', () {
    test('[success]', () async {
      when(mockNoteDbDataSourceTest.insertNote(any)).thenAnswer((_) async => 1);

      final result = await noteRepository.insertNote(noteModel);

      verify(mockNoteDbDataSourceTest.insertNote(any));
      expect(result, isNotNull);
      expect(result, 1);
    });

    test('[failed]', () async {
      when(mockNoteDbDataSourceTest.insertNote(any)).thenAnswer((_) async => null);

      final result = await noteRepository.insertNote(noteModel);

      verify(mockNoteDbDataSourceTest.insertNote(any));
      expect(result, isNull);
    });
  });

  group('NoteRepository updateNote', () {
    test('[success]', () async {
      when(mockNoteDbDataSourceTest.updateNote(any)).thenAnswer((_) async => 'success');

      final result = await noteRepository.updateNote(noteModel);

      verify(mockNoteDbDataSourceTest.updateNote(any));
      expect(result, isNotNull);
      expect(result, isA<String>());
    });

    test('[failed]', () async {
      when(mockNoteDbDataSourceTest.updateNote(any)).thenAnswer((_) async => null);

      final result = await noteRepository.updateNote(noteModel);

      verify(mockNoteDbDataSourceTest.updateNote(any));
      expect(result, isNull);
    });
  });

  group('NoteRepository deleteNote', () {
    test('[success]', () async {
      when(mockNoteDbDataSourceTest.deleteNote(any)).thenAnswer((_) async => 1);

      final result = await noteRepository.deleteNote(noteModel.id!);

      verify(mockNoteDbDataSourceTest.deleteNote(any));
      expect(result, isNotNull);
      expect(result, isA<int>());
      expect(result, 1);
    });

    test('[failed]', () async {
      when(mockNoteDbDataSourceTest.deleteNote(any)).thenAnswer((_) async => null);

      final result = await noteRepository.deleteNote(noteModel.id!);

      verify(mockNoteDbDataSourceTest.deleteNote(any));
      expect(result, isNull);
    });
  });
}
