import '../entities/note_entity.dart';

abstract class INoteRepository {
  Future<List<NoteEntity>?> getNotesByUserId(int userId);
  Future<NoteEntity?> getNoteById(int noteId);
  Future<int?> insertNote(NoteEntity? data);
  Future<String?> updateNote(NoteEntity? data);
  Future<int?> deleteNote(int id);
}
