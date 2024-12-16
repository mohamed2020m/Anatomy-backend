import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../Endpoints.dart';
import '../dioClient.dart';

class UserDetailApi {
  final DioClient dioClient;
  final storage = const FlutterSecureStorage();
  UserDetailApi({required this.dioClient});
  
  Future<Response> userDetailApi() async {
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
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updateUserDetailApi(String firstName, String lastName) async {
    try {
      final token = await storage.read(key: "token");
      if (token == null) {
        throw Exception("Token is missing");
      }
      final Response response = await dioClient.put('${Endpoints.baseUrl}${Endpoints.userInfo}',
        data: {
          "firstName": firstName,
          "lastName": lastName
        },
        options: Options(headers: {
          "authorization": 'Bearer $token'
        }        
      ));
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
