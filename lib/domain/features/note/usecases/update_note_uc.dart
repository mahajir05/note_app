import '../entities/note_entity.dart';
import '../repositories/i_note_repository.dart';

class UpdateNoteUc {
  final INoteRepository repository;

  UpdateNoteUc(this.repository);

  Future<String?> call(NoteEntity? data) {
    return repository.updateNote(data);
  }
}
