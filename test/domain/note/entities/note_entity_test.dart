import 'package:deptech_app/domain/features/note/entities/note_entity.dart';
import 'package:deptech_app/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/timezone.dart';

void main() {
  setUpAll(() {
    setupTimezone();
  });

  test(
    'NoteEntity is a valid entity',
    () {
      var noteData = NoteEntity(
        userId: 1,
        id: 1,
        title: 'note title',
        description: 'note desc',
        dateTime: TZDateTime.now(local),
        dateTimeReminder: TZDateTime.now(local),
      );

      expect(noteData.userId, isA<int>());
      expect(noteData.id, isA<int>());
      expect(noteData.title, isA<String>());
      expect(noteData.description, isA<String>());
      expect(noteData.dateTime, isA<TZDateTime>());
      expect(noteData.dateTimeReminder, isA<TZDateTime>());
    },
  );
}
