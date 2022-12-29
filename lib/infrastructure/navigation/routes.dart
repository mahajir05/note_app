// ignore_for_file: constant_identifier_names

class Routes {
  static Future<String> get initialRoute async {
    // TODO: implement method
    return AUTH;
  }

  static const AUTH = '/auth';
  static const HOME = '/home';
  static const PROFILE = '/profile';
  static const ADD_NOTE = '/add-note';
}
