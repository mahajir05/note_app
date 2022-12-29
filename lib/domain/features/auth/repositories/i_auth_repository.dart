abstract class IAuthRepository {
  /// if have session will return userId
  Future<int?> checkSession();
  Future<int?> login(String email, String password);
}
