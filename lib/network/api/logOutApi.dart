import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../Endpoints.dart';
import '../dioClient.dart';

class LogOutApi {
  final DioClient dioClient;
  final storage = const FlutterSecureStorage();
  LogOutApi({required this.dioClient});
  Future<Response> logOutApi() async {
    try {
      final Response response = await dioClient.post(Endpoints.logout,
          options: Options(headers: {
            "Authorization": 'Bearer ${await storage.read(key: "token")}'
          }));
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
