import '../repositories/i_note_repository.dart';

class DeleteNoteUc {
  final INoteRepository repository;

  DeleteNoteUc(this.repository);

  Future<int?> call(int id) {
    return repository.deleteNote(id);
  }
}
