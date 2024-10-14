import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api/logOutApi.dart';
import '../dioException.dart';

class LogOutRepository {
  final storage = const FlutterSecureStorage();
  final LogOutApi logoutApi;
  LogOutRepository(this.logoutApi);
  Future logout() async {
    try {
      final response = await logoutApi.logOutApi();
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

}
