// Mocks generated by Mockito 5.3.2 from annotations
// in deptech_app/test/domain/features/user/usecases/update_user_data_uc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:deptech_app/domain/features/user/entities/user_data_entity.dart'
    as _i4;
import 'package:mockito/mockito.dart' as _i1;

import 'update_user_data_uc_test.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [IUserRepositoryTest].
///
/// See the documentation for Mockito's code generation for more information.
class MockIUserRepositoryTest extends _i1.Mock
    implements _i2.IUserRepositoryTest {
  MockIUserRepositoryTest() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<List<_i4.UserDataEntity?>?> getAllUserData(bool? isFromLocal) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAllUserData,
          [isFromLocal],
        ),
        returnValue: _i3.Future<List<_i4.UserDataEntity?>?>.value(),
      ) as _i3.Future<List<_i4.UserDataEntity?>?>);
  @override
  _i3.Future<_i4.UserDataEntity?> getUserData(int? id) => (super.noSuchMethod(
        Invocation.method(
          #getUserData,
          [id],
        ),
        returnValue: _i3.Future<_i4.UserDataEntity?>.value(),
      ) as _i3.Future<_i4.UserDataEntity?>);
  @override
  _i3.Future<String?> updateUserData(
    int? id,
    _i4.UserDataEntity? data,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateUserData,
          [
            id,
            data,
          ],
        ),
        returnValue: _i3.Future<String?>.value(),
      ) as _i3.Future<String?>);
  @override
  _i3.Future<int?> insertUserData(
    int? id,
    _i4.UserDataEntity? data,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #insertUserData,
          [
            id,
            data,
          ],
        ),
        returnValue: _i3.Future<int?>.value(),
      ) as _i3.Future<int?>);
  @override
  _i3.Future<bool> logout() => (super.noSuchMethod(
        Invocation.method(
          #logout,
          [],
        ),
        returnValue: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);
}
