import 'package:equatable/equatable.dart';
import 'package:timezone/timezone.dart';

class UserDataEntity extends Equatable {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final TZDateTime? dob;
  final String? gender;
  final String? password;
  final String? photoProfile;

  const UserDataEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.dob,
    this.gender,
    this.password,
    this.photoProfile,
  });

  @override
  List<Object?> get props => [id, firstName, lastName, email, dob, gender, password, photoProfile];
}
