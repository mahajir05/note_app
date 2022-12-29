import '../../../../../domain/features/note/entities/note_entity.dart';
import '../../../../../domain/features/note/repositories/i_note_repository.dart';
import '../data_sources/note_db_data_source.dart';
import '../models/note_model.dart';

class NoteRepository implements INoteRepository {
  final INoteDbDataSource dbDataSource;

  NoteRepository({required this.dbDataSource});

  @override
  Future<List<NoteEntity>?> getNotesByUserId(int userId) async {
    final data = await dbDataSource.getNotesByUserId(userId);
    return data?.data;
  }

  @override
  Future<NoteEntity?> getNoteById(int noteId) {
    return dbDataSource.getNoteById(noteId);
  }

  @override
  Future<int?> insertNote(NoteEntity? data) {
    final dt = NoteModel(
      userId: data?.userId,
      id: data?.id,
      title: data?.title,
      description: data?.description,
      datetimeTs: data?.dateTime?.millisecondsSinceEpoch,
      datetimeReminderTs: data?.dateTimeReminder?.millisecondsSinceEpoch,
      hourInterval: data?.hourInterval,
      isRemind: data?.isRemind == true ? 1 : 0,
    );
    return dbDataSource.insertNote(dt);
  }

  @override
  Future<String?> updateNote(NoteEntity? data) {
    final dt = NoteModel(
      userId: data?.userId,
      id: data?.id,
      title: data?.title,
      description: data?.description,
      datetimeTs: data?.dateTime?.millisecondsSinceEpoch,
      datetimeReminderTs: data?.dateTimeReminder?.millisecondsSinceEpoch,
      hourInterval: data?.hourInterval,
      isRemind: data?.isRemind == true ? 1 : 0,
    );
    return dbDataSource.updateNote(dt);
  }

  @override
  Future<int?> deleteNote(int id) {
    return dbDataSource.deleteNote(id);
  }
}
