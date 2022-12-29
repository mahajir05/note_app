import 'package:deptech_app/infrastructure/dal/daos/auth/data_sources/i_auth_data_source.dart';
import 'package:deptech_app/infrastructure/dal/daos/auth/repositories/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_repository_test.mocks.dart';

class IAuthDataSourceTest extends Mock implements IAuthDataSource {}

@GenerateMocks([IAuthDataSourceTest])
void main() {
  late AuthRepository authRepository;
  late MockIAuthDataSourceTest mockIAuthDataSourceTest;

  setUpAll(() {
    mockIAuthDataSourceTest = MockIAuthDataSourceTest();
    authRepository = AuthRepository(dataSource: mockIAuthDataSourceTest);
  });

  int userId = 1;
  String email = 'admin@email.com';
  String password = 'admin';

  test('AuthRepository [success]', () async {
    when(mockIAuthDataSourceTest.login(email, password)).thenAnswer((realInvocation) async => userId);

    final result = await authRepository.login(email, password);

    expect(result, isA<int>());
    expect(result, equals(userId));
  });

  test('AuthRepository [failed]', () async {
    when(mockIAuthDataSourceTest.login(email, password)).thenAnswer((realInvocation) async => null);

    final result = await authRepository.login(email, password);

    expect(result, isNull);
  });
}
