// ignore_for_file: null_argument_to_non_null_type

import 'package:deptech_app/infrastructure/dal/daos/user/data_sources/user_db_data_source.dart';
import 'package:deptech_app/infrastructure/dal/daos/user/models/user_data_model.dart';
import 'package:deptech_app/infrastructure/dal/services/db_service.dart';
import 'package:deptech_app/infrastructure/dal/services/local_storage_service.dart';
import 'package:deptech_app/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../auth/data_sources/auth_db_source_test.mocks.dart';

class DbServiceTest extends Mock implements DbService {}

class LocalStorageTest extends Mock implements LocalStorage {}

@GenerateMocks([DbServiceTest])
void main() {
  late UserDbDataSource dataSource;
  late MockDbServiceTest mockDbServiceTest;

  late MockLocalStorageTest mockLocalStorageTest;
  late LocalStorageService localStorageService;

  late int userId;
  late String email;
  late String password;
  late UserDataModel data;

  setUpAll(() {
    setupTimezone();
    mockDbServiceTest = MockDbServiceTest();
    mockLocalStorageTest = MockLocalStorageTest();
    localStorageService = LocalStorageService(mockLocalStorageTest);
    dataSource = UserDbDataSource(dbService: mockDbServiceTest, localStorageService: localStorageService);
    userId = 1;
    email = 'admin@email.com';
    password = 'admin';
    data = UserDataModel(
      id: userId,
      firstName: 'Admin',
      lastName: 'Deptech App',
      email: email,
      dobTs: 833907600000,
      gender: 'L',
      password: password,
      photoProfile: '',
    );
  });

  group('DbUserSource get user data', () {
    test('[success]', () async {
      when(mockDbServiceTest.getSingle(
        tableName: USER_TABLE_NAME,
        where: 'id = ?',
        whereArgs: [userId],
      )).thenAnswer((_) async => data.toJson());

      final result = await dataSource.getUserData(userId);

      expect(result, data);
    });

    test('[failed]', () async {
      when(mockDbServiceTest.getSingle(
        tableName: USER_TABLE_NAME,
        where: 'id = ?',
        whereArgs: [userId],
      )).thenAnswer((_) async => {});

      final result = await dataSource.getUserData(userId);

      expect(result, isNull);
    });
  });

  group('DbUserSource update user data', () {
    var dataEdit = UserDataModel(photoProfile: 'assest');
    test('[success]', () async {
      when(mockDbServiceTest.update(tableName: USER_TABLE_NAME, id: userId, data: dataEdit.toJson()))
          .thenAnswer((_) async => 1);

      // var result = await dataSource.updateUserData(userId, {'photoProfile': 'assets'});
      var result = await dataSource.updateUserData(userId, dataEdit);

      verify(mockDbServiceTest.update(tableName: USER_TABLE_NAME, id: userId, data: dataEdit.toJson()));
      expect(result, isNotNull);
      expect(result, isA<String>());
    });

    test('[failed]', () async {
      when(mockDbServiceTest.update(tableName: USER_TABLE_NAME, id: userId, data: {}))
          .thenAnswer((_) => Future.value());

      // final result = await dataSource.updateUserData(userId, {'photoProfile': 'assets'});
      var result = await dataSource.updateUserData(userId, null);

      verify(mockDbServiceTest.update(tableName: USER_TABLE_NAME, id: userId, data: {}));
      expect(result, isNull);
    });
  });
}
