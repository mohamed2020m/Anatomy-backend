import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Endpoints {
  Endpoints._();
  final storage = const FlutterSecureStorage();
  // static const String baseUrl = "http://10.0.2.2:8080/api/v1";
  static const String baseUrl = "http://192.168.43.91:8080/api/v1";
  static const Duration receiveTimeout = Duration(seconds: 60);
  static const Duration connectionTimeout = Duration(seconds: 60);
  static const String category = '/categories';
  static const String quiz = '/quizzes';
  static const String question = '/questions';
  static const String favourite = '/favourites';
  static const String score = '/scores';
  static const String threeDObjects = '/threeDObjects';
  static const String note = '/notes';
  static const String login = "/auth/login";
  static const String logout = "/auth/logout";
  static const String userInfo = "/me";
  static const String searchByCategory = '/category/searchByCategory';
  static const String searchByObject3d = '/objet3d/searchByObject';
  static const String search = '/objet3d/search';
}
