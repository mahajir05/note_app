import 'package:deptech_app/domain/features/auth/repositories/i_auth_repository.dart';
import 'package:deptech_app/domain/features/auth/usecases/login_uc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_uc_test.mocks.dart';

class IAuthRepositoryTest extends Mock implements IAuthRepository {}

@GenerateMocks([IAuthRepositoryTest])
void main() {
  late LoginUc loginUc;
  late MockIAuthRepositoryTest mockIAuthRepositoryTest;

  setUpAll(() {
    mockIAuthRepositoryTest = MockIAuthRepositoryTest();
    loginUc = LoginUc(mockIAuthRepositoryTest);
  });

  int userId = 1;
  String email = 'admin@email.com';
  String password = 'admin';

  test('loginUc [succes]', () async {
    when(mockIAuthRepositoryTest.login(email, password)).thenAnswer((_) async => userId);

    final result = await loginUc(email, password);

    expect(result, isA<int>());
    expect(result, equals(userId));
  });

  test('loginUc [failed]', () async {
    when(mockIAuthRepositoryTest.login(email, password)).thenAnswer((_) async => null);

    final result = await loginUc(email, password);

    expect(result, isNull);
  });
}
