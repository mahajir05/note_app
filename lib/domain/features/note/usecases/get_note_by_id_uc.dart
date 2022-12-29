import '../entities/note_entity.dart';
import '../repositories/i_note_repository.dart';

class GetNoteByIdUc {
  final INoteRepository repository;

  GetNoteByIdUc(this.repository);

  Future<NoteEntity?> call(int noteId) {
    return repository.getNoteById(noteId);
  }
}
