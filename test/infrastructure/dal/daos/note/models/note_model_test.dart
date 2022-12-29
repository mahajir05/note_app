import 'package:deptech_app/domain/features/note/entities/note_entity.dart';
import 'package:deptech_app/infrastructure/dal/daos/note/models/note_model.dart';
import 'package:deptech_app/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Map<String, dynamic> jsonData;
  late NoteModel noteModel;

  setUpAll(() {
    setupTimezone();
    jsonData = {
      'userId': 1,
      'id': 1,
      'title': 'note title',
      'description': 'note desc',
      'datetimeTs': 833907600000,
      'datetimeReminderTs': 833907600000,
      'hourInterval': 0,
      'isRemind': 1,
    };

    noteModel = NoteModel(
      userId: 1,
      id: 1,
      title: 'note title',
      description: 'note desc',
      datetimeTs: 833907600000,
      datetimeReminderTs: 833907600000,
      hourInterval: 0,
      isRemind: 1,
    );
  });

  test('json to UserDataModel', () {
    var result = NoteModel.fromJson(jsonData);
    expect(result, isA<NoteModel>());
    expect(result, isA<NoteEntity>());
    expect(result.userId, equals(1));
    expect(result.id, equals(1));
    expect(result.title, equals('note title'));
    expect(result.description, equals('note desc'));
    expect(result.dateTime, equals(DateTime(1996, 06, 05)));
    expect(result.dateTimeReminder, equals(DateTime(1996, 06, 05)));
    expect(result, equals(noteModel));
  });

  test('UserDataModel to json', () {
    expect(noteModel, isA<NoteModel>());
    expect(noteModel, isA<NoteEntity>());
    var result = noteModel.toJson();
    expect(result, equals(jsonData));
  });
}
