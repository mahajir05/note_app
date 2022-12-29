import 'package:deptech_app/domain/features/note/entities/note_entity.dart';
import 'package:deptech_app/domain/features/note/repositories/i_note_repository.dart';
import 'package:deptech_app/domain/features/note/usecases/delete_note_uc.dart';
import 'package:deptech_app/domain/features/note/usecases/get_notes_by_user_id_uc.dart';
import 'package:deptech_app/domain/features/note/usecases/insert_note_uc.dart';
import 'package:deptech_app/domain/features/note/usecases/update_note_uc.dart';
import 'package:deptech_app/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:timezone/timezone.dart';

import 'note_usecase_test.mocks.dart';

class NoteRepositoryTest extends Mock implements INoteRepository {}

@GenerateMocks([NoteRepositoryTest])
void main() {
  late MockNoteRepositoryTest mockNoteRepositoryTest;

  late int userId;
  late NoteEntity noteEntity;

  setUpAll(() {
    setupTimezone();
    mockNoteRepositoryTest = MockNoteRepositoryTest();

    userId = 1;
    noteEntity = NoteEntity(
      id: 1,
      title: 'asd',
      description: 'qwe',
      dateTime: TZDateTime.now(local),
      dateTimeReminder: TZDateTime.now(local),
    );
  });

  group('getNotesByUserIdUc Usecase', () {
    late GetNotesByUserIdUc getNotesByUserIdUc;
    setUp(() {
      getNotesByUserIdUc = GetNotesByUserIdUc(mockNoteRepositoryTest);
    });

    test('[success]', () async {
      when(mockNoteRepositoryTest.getNotesByUserId(any)).thenAnswer((_) async => [noteEntity]);

      var result = await getNotesByUserIdUc(userId);

      verify(mockNoteRepositoryTest.getNotesByUserId(any));
      expect(result, isNotNull);
      expect(result, isA<List<NoteEntity>>());
    });

    test('[failed]', () async {
      when(mockNoteRepositoryTest.getNotesByUserId(any)).thenAnswer((_) async => null);

      var result = await getNotesByUserIdUc(userId);

      verify(mockNoteRepositoryTest.getNotesByUserId(any));
      expect(result, isNull);
    });
  });

  group('InsertNoteUc Usecase', () {
    late InsertNoteUc insertNoteUc;
    setUp(() {
      insertNoteUc = InsertNoteUc(mockNoteRepositoryTest);
    });

    test('[success]', () async {
      when(mockNoteRepositoryTest.insertNote(any)).thenAnswer((_) async => 1);

      var result = await insertNoteUc(noteEntity);

      verify(mockNoteRepositoryTest.insertNote(any));
      expect(result, isNotNull);
      expect(result, isA<int>());
    });

    test('[failed]', () async {
      when(mockNoteRepositoryTest.insertNote(any)).thenAnswer((_) async => null);

      var result = await insertNoteUc(noteEntity);

      verify(mockNoteRepositoryTest.insertNote(any));
      expect(result, isNull);
    });
  });

  group('UpdateNoteUc Usecase', () {
    late UpdateNoteUc updateNoteUc;
    setUp(() {
      updateNoteUc = UpdateNoteUc(mockNoteRepositoryTest);
    });

    test('[success]', () async {
      when(mockNoteRepositoryTest.updateNote(any)).thenAnswer((_) async => 'success');

      var result = await updateNoteUc(noteEntity);

      verify(mockNoteRepositoryTest.updateNote(any));
      expect(result, isNotNull);
      expect(result, isA<String>());
    });

    test('[failed]', () async {
      when(mockNoteRepositoryTest.updateNote(any)).thenAnswer((_) async => null);

      var result = await updateNoteUc(noteEntity);

      verify(mockNoteRepositoryTest.updateNote(any));
      expect(result, isNull);
    });
  });

  group('DeleteNoteUc Usecase', () {
    late DeleteNoteUc deleteNoteUc;
    setUp(() {
      deleteNoteUc = DeleteNoteUc(mockNoteRepositoryTest);
    });

    test('[success]', () async {
      when(mockNoteRepositoryTest.deleteNote(any)).thenAnswer((_) async => 1);

      var result = await deleteNoteUc(noteEntity.id!);

      verify(mockNoteRepositoryTest.deleteNote(any));
      expect(result, isNotNull);
      expect(result, isA<int>());
    });

    test('[failed]', () async {
      when(mockNoteRepositoryTest.deleteNote(any)).thenAnswer((_) async => null);

      var result = await deleteNoteUc(noteEntity.id!);

      verify(mockNoteRepositoryTest.deleteNote(any));
      expect(result, isNull);
    });
  });
}
