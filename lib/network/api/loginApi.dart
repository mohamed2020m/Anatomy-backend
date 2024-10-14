// import 'dart:io';
import 'package:dio/dio.dart';
import '../Endpoints.dart';
import '../dioClient.dart';

class LogInApi {
  final DioClient dioClient;

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
}
