import '../repositories/i_auth_repository.dart';

class LoginUc {
  final IAuthRepository repo;

  LoginUc(this.repo);

  Future<int?> call(String email, String password) {
    return repo.login(email, password);
  }
}
