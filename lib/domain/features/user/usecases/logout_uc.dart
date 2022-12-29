import '../repositories/i_user_repository.dart';

class LogoutUc {
  final IUserRepository repo;

  LogoutUc(this.repo);

  Future<bool> call() => repo.logout();
}
