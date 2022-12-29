import '../../../../../domain/features/user/entities/user_data_entity.dart';
import '../../../../../domain/features/user/repositories/i_user_repository.dart';
import '../data_sources/i_user_data_source.dart';
import '../models/user_data_model.dart';

class UserRepository implements IUserRepository {
  final IUserDataSource dbDataSource;

  UserRepository({
    required this.dbDataSource,
  });

  @override
  Future<List<UserDataEntity?>?> getAllUserData(bool? isFromLocal) async {
    var resultDb = await dbDataSource.getAllUserData();
    var result = resultDb?.data;
    return result;
  }

  @override
  Future<UserDataEntity?> getUserData(int id) async {
    return await dbDataSource.getUserData(id);
  }

  @override
  Future<String?> updateUserData(int id, UserDataEntity? data) async {
    var dt = UserDataModel(
      id: data?.id,
      firstName: data?.firstName,
      lastName: data?.lastName,
      email: data?.email,
      dobTs: data?.dob?.millisecondsSinceEpoch,
      gender: data?.gender,
      password: data?.password,
      photoProfile: data?.photoProfile,
    );
    return await dbDataSource.updateUserData(id, dt);
  }

  @override
  Future<int?> insertUserData(int id, UserDataEntity? data) async {
    var dt = UserDataModel(
      id: data?.id,
      firstName: data?.firstName,
      lastName: data?.lastName,
      email: data?.email,
      dobTs: data?.dob?.millisecondsSinceEpoch,
      gender: data?.gender,
      password: data?.password,
      photoProfile: data?.photoProfile,
    );
    return await dbDataSource.insertUserData(id, dt);
  }

  @override
  Future<bool> logout() => dbDataSource.logout();
}
