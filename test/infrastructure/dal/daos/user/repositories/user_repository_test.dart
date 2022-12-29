import 'package:deptech_app/domain/features/user/entities/user_data_entity.dart';
import 'package:deptech_app/infrastructure/dal/daos/user/data_sources/i_user_data_source.dart';
import 'package:deptech_app/infrastructure/dal/daos/user/models/user_data_model.dart';
import 'package:deptech_app/infrastructure/dal/daos/user/repositories/user_repository.dart';
import 'package:deptech_app/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_repository_test.mocks.dart';

class IUserDataSourceTest extends Mock implements IUserDataSource {}

@GenerateMocks([IUserDataSourceTest])
void main() {
  late UserRepository repository;
  late MockIUserDataSourceTest mockIUserDataSourceTest;

  late UserDataModel userDataModel;
  late UserDataEntity userDataEntity;
  late int userId;

  setUpAll(() {
    setupTimezone();
    mockIUserDataSourceTest = MockIUserDataSourceTest();
    repository = UserRepository(
      dbDataSource: mockIUserDataSourceTest,
      // localDataSource: mockIUserDataSourceTest,
    );
    userId = 1;
    userDataModel = UserDataModel(
      id: userId,
      firstName: 'Admin',
      lastName: 'Deptech App',
      email: 'admin@email.com',
      dobTs: 833907600000,
      gender: 'L',
      password: 'admin',
      photoProfile: 'pp',
    );
    userDataEntity = userDataModel;
  });

  group('UserRepository implementation get user data', () {
    test('[success]', () async {
      when(mockIUserDataSourceTest.getUserData(any)).thenAnswer((_) async => userDataModel);

      var result = await repository.getUserData(userId);

      verify(mockIUserDataSourceTest.getUserData(userId));
      expect(result, userDataEntity);
    });

    test('[failed]', () async {
      when(mockIUserDataSourceTest.getUserData(userId)).thenAnswer((_) async => null);

      var result = await repository.getUserData(userId);

      verify(mockIUserDataSourceTest.getUserData(userId));
      expect(result, isNull);
    });
  });

  group('UserRepository implementation update user data', () {
    test('[success]', () async {
      when(mockIUserDataSourceTest.updateUserData(any, any)).thenAnswer((_) async => 'userDataModel');

      var result = await repository.updateUserData(userId, UserDataEntity());

      // verify(mockIUserDataSourceTest.updateUserData(userId, {'photoProfile': 'assets'}));
      verify(mockIUserDataSourceTest.updateUserData(userId, UserDataModel()));
      expect(result, isNotNull);
      expect(result, isA<String>());
    });

    test('[failed]', () async {
      when(mockIUserDataSourceTest.updateUserData(any, any)).thenAnswer((_) async => null);

      var result = await repository.updateUserData(userId, UserDataEntity());

      verify(mockIUserDataSourceTest.updateUserData(userId, UserDataModel()));
      expect(result, isNull);
    });
  });
}
