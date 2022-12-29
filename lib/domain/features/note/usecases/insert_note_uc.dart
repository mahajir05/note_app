import '../entities/note_entity.dart';
import '../repositories/i_note_repository.dart';

class InsertNoteUc {
  final INoteRepository repository;

  InsertNoteUc(this.repository);

  Future<int?> call(NoteEntity? data) {
    return repository.insertNote(data);
  }
}
