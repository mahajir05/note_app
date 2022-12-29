import '../entities/user_data_entity.dart';

abstract class IUserRepository {
  /// if [isFromLocal] == null => then check on local first, then check from db
  Future<List<UserDataEntity?>?> getAllUserData(bool? isFromLocal);

  Future<UserDataEntity?> getUserData(int id);
  Future<String?> updateUserData(int id, UserDataEntity? data);
  Future<int?> insertUserData(int id, UserDataEntity? data);
  Future<bool> logout();
}
