import 'package:deptech_app/infrastructure/dal/daos/auth/data_sources/auth_db_source.dart';
import 'package:deptech_app/infrastructure/dal/daos/user/models/user_data_model.dart';
import 'package:deptech_app/infrastructure/dal/services/db_service.dart';
import 'package:deptech_app/infrastructure/dal/services/local_storage_service.dart';
import 'package:deptech_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_db_source_test.mocks.dart';

class DbServiceTest extends Mock implements DbService {}

class LocalStorageTest extends Mock implements LocalStorage {}

@GenerateMocks([DbServiceTest, LocalStorageTest])
void main() {
  late AuthDbSource authDbSource;
  late MockDbServiceTest mockDbServiceTest;
  late MockLocalStorageTest mockLocalStorageTest;
  late LocalStorageService localStorageService;
  late UserDataModel data;
  late int userId;
  late String email;
  late String password;

  setUpAll(() {
    setupTimezone();
    mockDbServiceTest = MockDbServiceTest();
    mockLocalStorageTest = MockLocalStorageTest();
    localStorageService = LocalStorageService(mockLocalStorageTest);
    authDbSource = AuthDbSource(
      dbService: mockDbServiceTest,
      localStorageService: localStorageService,
    );

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
      photoProfile: 'pp',
    );
  });

  group('Check Session', () {
    test('[have]', () async {
      when(localStorageService.storage.getItem(KEY_STORAGE_CHECK_SESSION_LOCAL)).thenAnswer((_) async => userId);

      final result = await authDbSource.checkSession();

      expect(result, isA<int>());
      expect(result, userId);
    });

    test('[not have]', () async {
      when(localStorageService.storage.getItem(KEY_STORAGE_CHECK_SESSION_LOCAL)).thenAnswer((_) async => null);

      final result = await authDbSource.checkSession();

      expect(result, isNull);
    });
  });

  group('Login', () {
    test('[success]', () async {
      when(mockDbServiceTest.getSingle(
        tableName: USER_TABLE_NAME,
        where: 'email = ? AND password = ?',
        whereArgs: [email, password],
      )).thenAnswer((_) async => data.toJson());
      when(localStorageService.storage.setItem(KEY_STORAGE_CHECK_SESSION_LOCAL, data.toJson()['id'] as int))
          .thenAnswer((_) async => VoidCallbackAction());

      final result = await authDbSource.login(email, password);

      expect(result, isA<int>());
      expect(result, data.id);
    });

    test('[failed]', () async {
      when(mockDbServiceTest.getSingle(
        tableName: USER_TABLE_NAME,
        where: 'email = ? AND password = ?',
        whereArgs: [email, password],
      )).thenAnswer((_) async => {});

      final result = await authDbSource.login(email, password);

      expect(result, isNull);
    });
  });
}
