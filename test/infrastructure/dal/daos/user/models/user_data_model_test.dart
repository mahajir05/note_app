import 'package:deptech_app/domain/features/user/entities/user_data_entity.dart';
import 'package:deptech_app/infrastructure/dal/daos/user/models/user_data_model.dart';
import 'package:deptech_app/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Map<String, dynamic> jsonData;
  late UserDataModel userDataModel;

  setUpAll(() {
    setupTimezone();
    jsonData = {
      'id': 1,
      'firstName': 'Admin',
      'lastName': 'Deptech App',
      'email': 'admin@email.com',
      'dobTs': 833907600000,
      'gender': 'L',
      'password': 'admin',
      'photoProfile': 'pp',
    };

    userDataModel = UserDataModel(
      id: 1,
      firstName: 'Admin',
      lastName: 'Deptech App',
      email: 'admin@email.com',
      dobTs: 833907600000,
      gender: 'L',
      password: 'admin',
      photoProfile: 'pp',
    );
  });

  test('json to UserDataModel', () {
    var result = UserDataModel.fromJson(jsonData);
    expect(result, isA<UserDataModel>());
    expect(result, isA<UserDataEntity>());
    expect(result.id, equals(1));
    expect(result.firstName, equals('Admin'));
    expect(result.lastName, equals('Deptech App'));
    expect(result.email, equals('admin@email.com'));
    expect(result.dob, equals(DateTime(1996, 06, 05)));
    expect(result.gender, equals('L'));
    expect(result.password, equals('admin'));
    expect(result.photoProfile, equals('pp'));
    expect(result, equals(userDataModel));
  });

  test('UserDataModel to json', () {
    expect(userDataModel, isA<UserDataModel>());
    expect(userDataModel, isA<UserDataEntity>());
    var result = userDataModel.toJson();
    expect(result, equals(jsonData));
  });
}
