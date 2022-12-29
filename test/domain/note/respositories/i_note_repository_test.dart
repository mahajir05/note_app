import 'package:deptech_app/domain/features/note/entities/note_entity.dart';
import 'package:deptech_app/domain/features/note/repositories/i_note_repository.dart';
import 'package:deptech_app/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:timezone/timezone.dart';

import 'i_note_repository_test.mocks.dart';

class INoteRepositoryTest extends Mock implements INoteRepository {}

@GenerateMocks([INoteRepositoryTest])
void main() {
  late MockINoteRepositoryTest mockINoteRepositoryTest;

  late int userId;
  late NoteEntity noteEntity;

  setUpAll(() {
    setupTimezone();
    mockINoteRepositoryTest = MockINoteRepositoryTest();

    userId = 1;
    noteEntity = NoteEntity(
      id: 1,
      title: 'asd',
      description: 'qwe',
      dateTime: TZDateTime.now(local),
      dateTimeReminder: TZDateTime.now(local),
    );
  });

  test('INoteRepository getNoteByUserId', () async {
    when(mockINoteRepositoryTest.getNotesByUserId(userId)).thenAnswer((_) async => [noteEntity]);

    final result = await mockINoteRepositoryTest.getNotesByUserId(userId);

    expect(result, isNotNull);
    expect(result, isA<List<NoteEntity>>());
  });

  test('INoteRepository insertNote', () async {
    when(mockINoteRepositoryTest.insertNote(noteEntity)).thenAnswer((_) async => 1);

    final result = await mockINoteRepositoryTest.insertNote(noteEntity);

    expect(result, isNotNull);
    expect(result, isA<int>());
  });
}
