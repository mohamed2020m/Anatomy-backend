import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Endpoints {
  Endpoints._();
  final storage = const FlutterSecureStorage();
  static const String baseUrl = "http://10.0.2.2:8080/api/v1";
  static const Duration receiveTimeout = Duration(seconds: 60);
  static const Duration connectionTimeout = Duration(seconds: 60);
  static const String category = '/category';
  static const String object3d = '/objet3d/';
  static const String note = '/notes/';
  static const String searchByCategory = '/category/searchByCategory';
  static const String searchByObject3d = '/objet3d/searchByObject';
  static const String search = '/objet3d/search';
  static const String login = "/auth/authenticate";
  static const String logout = "/auth/logout";
  static const String creatsUser = "/auth/register";
  static const String userInfo = "/auth/user/";
  //BigItemSection.categoryId
}
