import 'package:timezone/timezone.dart';

import '../../../../../domain/features/user/entities/user_data_entity.dart';

class UserDataModel extends UserDataEntity {
  UserDataModel({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    num? dobTs,
    String? gender,
    String? password,
    String? photoProfile,
  }) : super(
          id: id,
          firstName: firstName,
          lastName: lastName,
          email: email,
          dob: dobTs != null ? TZDateTime.fromMillisecondsSinceEpoch(local, dobTs.toInt()) : null,
          gender: gender,
          password: password,
          photoProfile: photoProfile,
        );

  UserDataModel.fromJson(Map<String, dynamic> json)
      : super(
          id: json['id'],
          firstName: json['firstName'],
          lastName: json['lastName'],
          email: json['email'],
          dob: json['dobTs'] != null
              ? TZDateTime.fromMillisecondsSinceEpoch(local, (json['dobTs'] as num).toInt())
              : null,
          gender: json['gender'],
          password: json['password'],
          photoProfile: json['photoProfile'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = super.id;
    data['firstName'] = super.firstName;
    data['lastName'] = super.lastName;
    data['email'] = super.email;
    data['dobTs'] = super.dob?.millisecondsSinceEpoch;
    data['gender'] = super.gender;
    data['password'] = super.password;
    data['photoProfile'] = super.photoProfile;
    return data;
  }
}
