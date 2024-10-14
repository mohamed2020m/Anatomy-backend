import 'package:dio/dio.dart';

import '../Endpoints.dart';
import '../dioClient.dart';

class CreateUserApi {
  final DioClient dioClient;

  CreateUserApi({required this.dioClient});
  
  Future<Response> createUserApi(
      String firstname, String lastname, String email, String password) async {
    try {
      final Response response =
          await dioClient.post(Endpoints.creatsUser, data: {
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "password": password
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
