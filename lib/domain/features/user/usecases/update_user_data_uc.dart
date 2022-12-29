import '../entities/user_data_entity.dart';
import '../repositories/i_user_repository.dart';

class UpdateUserDataUc {
  final IUserRepository repo;

  UpdateUserDataUc(this.repo);

  Future<String?> call(int id, UserDataEntity? data) {
    return repo.updateUserData(id, data);
  }
}
