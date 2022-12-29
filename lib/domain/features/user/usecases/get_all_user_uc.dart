import '../entities/user_data_entity.dart';
import '../repositories/i_user_repository.dart';

class GetAllUserUc {
  final IUserRepository userRepository;

  GetAllUserUc(this.userRepository);

  Future<List<UserDataEntity?>?> call(bool? isFromLocal) {
    return userRepository.getAllUserData(isFromLocal);
  }
}
