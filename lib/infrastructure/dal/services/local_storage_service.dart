// ignore_for_file: constant_identifier_names

import 'package:localstorage/localstorage.dart';

const String KEY_STORAGE_SERVICE_USER_LOCAL = 'KEY_STORAGE_SERVICE_USER_LOCAL';

const String KEY_STORAGE_CHECK_SESSION_LOCAL = 'KEY_STORAGE_CHECK_SESSION_LOCAL';

class LocalStorageService {
  final LocalStorage storage;

  LocalStorageService(this.storage);
}
