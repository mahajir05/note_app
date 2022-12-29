abstract class IAuthDataSource {
  /// if have session will return userId
  Future<int?> checkSession();
  Future<int?> login(String email, String password);
}
