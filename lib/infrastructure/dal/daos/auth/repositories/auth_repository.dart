import '../../../../../domain/features/auth/repositories/i_auth_repository.dart';
import '../data_sources/i_auth_data_source.dart';

class AuthRepository implements IAuthRepository {
  final IAuthDataSource dataSource;

  AuthRepository({required this.dataSource});

  @override
  Future<int?> checkSession() => dataSource.checkSession();

  @override
  Future<int?> login(String email, String password) => dataSource.login(email, password);
}
