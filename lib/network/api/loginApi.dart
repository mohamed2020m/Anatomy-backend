import 'package:dio/dio.dart';
import '../Endpoints.dart';
import '../dioClient.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class LogInApi {
  final DioClient dioClient;
  final storage = const FlutterSecureStorage();

  LogInApi({required this.dioClient});
  
  Future<Response> logInApi(String email, String password) async {
    try {
      final Response response = await dioClient.post(
        Endpoints.login,
        data: {"email": email, "password": password},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAndStoreUserDetails() async {
    try {
      final token = await storage.read(key: "token");
      if (token == null) {
        throw Exception("Token is missing");
      }
      final Response response = await dioClient.get('${Endpoints.baseUrl}${Endpoints.userInfo}',
        options: Options(headers: {
          "authorization": 'Bearer $token'
        }
      ));

      // Extract and store user details in secure storage
      final userData = response.data;
      storeToken(userData['id'].toString(), 'user_id');
      storeToken(userData['firstName'], 'first_name');
      storeToken(userData['lastName'], 'last_name');
      storeToken(userData['email'], 'email');

     // return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> storeToken(String? token, String key) async {
    if (token == null) return;
    await storage.write(key: key, value: token);
  }

}
