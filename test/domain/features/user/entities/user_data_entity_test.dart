import 'package:deptech_app/domain/features/user/entities/user_data_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/timezone.dart';
import 'package:deptech_app/main.dart';

void main() {
  setUpAll(() {
    setupTimezone();
  });

  test(
    'UserDataEntity is a valid entity',
    () {
      var userData = UserDataEntity(
        id: 1,
        firstName: 'firstName',
        lastName: 'lastName',
        email: 'email',
        dob: TZDateTime.now(local),
        gender: 'L',
        password: 'password',
        photoProfile: 'pp',
      );

      expect(userData.id, isA<int>());
      expect(userData.firstName, isA<String>());
      expect(userData.lastName, isA<String>());
      expect(userData.email, isA<String>());
      expect(userData.dob, isA<DateTime>());
      expect(userData.gender, isA<String>());
      expect(userData.password, isA<String>());
      expect(userData.photoProfile, isA<String>());
    },
  );
}
