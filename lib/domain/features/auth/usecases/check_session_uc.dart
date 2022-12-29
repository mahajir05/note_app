import '../repositories/i_auth_repository.dart';

class CheckSessionUc {
  final IAuthRepository repo;

  CheckSessionUc(this.repo);

  Future<int?> call() {
    return repo.checkSession();
  }
}
