import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api/loginApi.dart';
import '../dioException.dart';

// class LogInRepository {
//   final LogInApi loginApi;
//   final storage = const FlutterSecureStorage();

//   LogInRepository(this.loginApi);
//   Future getUserRequested(String email, String password) async {
//     try {
//       final response = await loginApi.logInApi(email, password,);
//       print("response: ${response.data}");

//       storeToken(response.data["accessToken"], 'token');
//       storeToken('${response.data["id"]}','user_id');
//     } on DioException catch (e) {
//       final errorMessage = DioExceptions.fromDioError(e).toString();
//       throw errorMessage;
//     }
//   }

//   storeToken(String? token,String key) async {
//     if (token == null) return;
//     await storage.write(key: key, value: token);
    
//   }
// }


import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api/loginApi.dart';
import '../dioException.dart';
import '../api/userDetailApi.dart';

class LogInRepository {
  final LogInApi loginApi;
  final storage = const FlutterSecureStorage();
  late UserDetailApi userDetail;

  LogInRepository(this.loginApi);


  Future getUserRequested(String email, String password) async {
    try {
      final response = await loginApi.logInApi(email, password,);
      print("response: ${response.data}");

      storeToken(response.data["accessToken"], 'token');
      // Fetch additional user details after login
      await fetchAndStoreUserDetails();
    
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

    Future<void> fetchAndStoreUserDetails() async {
    try {

      final response = await userDetail.userDetailApi();
      print("User detail response: ${response.data}");

      // Extract and store user details in secure storage
      final userData = response.data;
      storeToken(userData['id'], 'user_id');
      storeToken(userData['firstName'], 'first_name');
      storeToken(userData['lastName'], 'last_name');
      storeToken(userData['email'], 'email');

    } catch (e) {
      print("Error fetching user details: $e");
      throw Exception("Failed to fetch user details.");
    }
  }

  storeToken(String? token, String key) async {
    if (token == null) return;
    await storage.write(key: key, value: token);
    
  }
}
