import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api/loginApi.dart';
import '../dioException.dart';

class LogInRepository {
  final LogInApi loginApi;
  final storage = const FlutterSecureStorage();

  LogInRepository(this.loginApi);
  Future getUserRequested(String email, String password) async {
    try {
      final response = await loginApi.logInApi(email, password,);
      storeToken(response.data["access_token"],'token');
      storeToken('${response.data["user_id"]}','id');
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  storeToken(String? token,String key) async {
    if (token == null) return;
    await storage.write(key: key, value: token);
    
  }
}
