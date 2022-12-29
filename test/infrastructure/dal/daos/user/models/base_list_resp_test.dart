import 'package:deptech_app/infrastructure/dal/daos/user/models/base_list_resp.dart';
import 'package:deptech_app/infrastructure/dal/daos/user/models/user_data_model.dart';
import 'package:deptech_app/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() {
    setupTimezone();
  });

  var jsonArray = [
    {
      'id': 1,
      'firstName': 'Admin',
      'lastName': 'Deptech App',
      'email': 'admin@email.com',
      'dobTs': 833907600000,
      'gender': 'L',
      'password': 'admin',
      'photoProfile': 'pp',
    }
  ];
  test('BaseListResp fromJson', () {
    BaseListResp<UserDataModel> resp = BaseListResp.fromJson(jsonArray, UserDataModel.fromJson);
    var result = resp.data;
    expect(result, isA<List<UserDataModel>>());
    expect(result?[0], isA<UserDataModel>());
    expect(result?[0].toJson(), jsonArray[0]);
  });
}
