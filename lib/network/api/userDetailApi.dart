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
      final Response response = await dioClient.get('${Endpoints.userInfo}${await storage.read(key: "id")}',
          options: Options(headers: {
            "authorization": 'Bearer ${await storage.read(key: "token")}'
          }));
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
