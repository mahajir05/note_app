import '../models/base_list_resp.dart';
import '../models/user_data_model.dart';

abstract class IUserDataSource {
  Future<BaseListResp<UserDataModel?>?> getAllUserData();
  Future<UserDataModel?> getUserData(int id);

  /// if return null = update failed
  ///
  /// if return != null = return description of data changed made count
  Future<String?> updateUserData(int id, UserDataModel? data);
  Future<int?> insertUserData(int id, UserDataModel? data);
  Future<bool> logout();
}
