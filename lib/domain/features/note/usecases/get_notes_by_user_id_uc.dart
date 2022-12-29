import '../entities/note_entity.dart';
import '../repositories/i_note_repository.dart';

class GetNotesByUserIdUc {
  final INoteRepository repository;

  GetNotesByUserIdUc(this.repository);

  Future<List<NoteEntity>?> call(int userId) {
    return repository.getNotesByUserId(userId);
  }
}
