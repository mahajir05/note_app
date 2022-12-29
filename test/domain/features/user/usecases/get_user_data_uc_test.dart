import 'package:deptech_app/domain/features/user/entities/user_data_entity.dart';
import 'package:deptech_app/domain/features/user/repositories/i_user_repository.dart';
import 'package:deptech_app/domain/features/user/usecases/get_user_data_uc.dart';
import 'package:deptech_app/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';

import 'get_user_data_uc_test.mocks.dart';

class IUserRepositoryTest extends Mock implements IUserRepository {}

@GenerateMocks([IUserRepositoryTest])
void main() {
  late GetUserDataUc usecase;
  late MockIUserRepositoryTest mockIUserRepo;
  late UserDataEntity userData;

  setUpAll(() {
    setupTimezone();
    mockIUserRepo = MockIUserRepositoryTest();
    usecase = GetUserDataUc(mockIUserRepo);
    userData = UserDataEntity(
      id: 1,
      firstName: 'firstName',
      lastName: 'lastName',
      email: 'email',
      dob: TZDateTime.now(local),
      gender: 'L',
      password: 'password',
      photoProfile: 'pp',
    );
  });

  // final userData = UserDataEntity(
  //   id: 1,
  //   firstName: 'firstName',
  //   lastName: 'lastName',
  //   email: 'email',
  //   dob: TZDateTime.now(local),
  //   gender: 'L',
  //   password: 'password',
  //   photoProfile: 'pp',
  // );

  test('GetUserDataUc [success]', () async {
    when(mockIUserRepo.getUserData(1)).thenAnswer((_) async {
      return userData;
    });

    var result = await usecase(1);

    expect(result, userData);
    verify(mockIUserRepo.getUserData(1));
    verifyNoMoreInteractions(mockIUserRepo);
  });

  test('GetUserDataUc [failed]', () async {
    int userId = 0;
    when(mockIUserRepo.getUserData(userId)).thenAnswer((_) async {
      return null;
    });

    var result = await usecase(userId);

    expect(result, isNull);
    verify(mockIUserRepo.getUserData(userId));
    verifyNoMoreInteractions(mockIUserRepo);
  });
}
