import '../entities/user_data_entity.dart';
import '../repositories/i_user_repository.dart';

class GetUserDataUc {
  final IUserRepository repo;

  GetUserDataUc(this.repo);

  Future<UserDataEntity?> call(int id) {
    return repo.getUserData(id);
  }
}
