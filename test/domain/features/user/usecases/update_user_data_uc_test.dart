import 'package:deptech_app/domain/features/user/entities/user_data_entity.dart';
import 'package:deptech_app/domain/features/user/repositories/i_user_repository.dart';
import 'package:deptech_app/domain/features/user/usecases/update_user_data_uc.dart';
import 'package:deptech_app/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'update_user_data_uc_test.mocks.dart';

class IUserRepositoryTest extends Mock implements IUserRepository {}

@GenerateMocks([IUserRepositoryTest])
void main() {
  late UpdateUserDataUc usecase;
  late MockIUserRepositoryTest mockIUserRepo;

  setUpAll(() {
    setupTimezone();
    mockIUserRepo = MockIUserRepositoryTest();
    usecase = UpdateUserDataUc(mockIUserRepo);
  });

  group('UpdateUserDataUc', () {
    var dataEdit = const UserDataEntity(photoProfile: 'assets');
    test('[success]', () async {
      int userId = 1;
      // when(mockIUserRepo.updateUserData(userId, {'photoProfile': 'assets'})).thenAnswer((_) async {
      //   return 'userData';
      // });
      when(mockIUserRepo.updateUserData(userId, dataEdit)).thenAnswer((_) async {
        return 'userData';
      });

      var result = await usecase(userId, dataEdit);

      verify(mockIUserRepo.updateUserData(userId, dataEdit));
      verifyNoMoreInteractions(mockIUserRepo);
      expect(result, isNotNull);
      expect(result, isA<String>());
    });

    test('[failed]', () async {
      int userId = 0;
      when(mockIUserRepo.updateUserData(userId, null)).thenAnswer((_) async {
        return null;
      });

      var result = await usecase(userId, null);

      verify(mockIUserRepo.updateUserData(userId, null));
      verifyNoMoreInteractions(mockIUserRepo);
      expect(result, isNull);
    });
  });
}
