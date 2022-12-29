import '../../../services/db_service.dart';
import '../../../services/local_storage_service.dart';
import 'i_auth_data_source.dart';

class AuthDbSource implements IAuthDataSource {
  final DbService dbService;
  final LocalStorageService localStorageService;

  AuthDbSource({required this.dbService, required this.localStorageService});

  @override
  Future<int?> checkSession() async {
    int? userId = await localStorageService.storage.getItem(KEY_STORAGE_CHECK_SESSION_LOCAL);
    return userId;
  }

  @override
  Future<int?> login(String email, String password) async {
    var data = await dbService.getSingle(
      tableName: USER_TABLE_NAME,
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (data.isEmpty) return null;
    await localStorageService.storage.setItem(KEY_STORAGE_CHECK_SESSION_LOCAL, data['id'] as int);
    return data['id'] as int;
  }
}
