import 'package:dio/dio.dart';

import '../api/createUserApi.dart';
import '../dioException.dart';

class CreateUserRepository {
  final CreateUserApi createUserApi;
  CreateUserRepository(this.createUserApi);

  Future<String> getmessage(
      String firstname, String lastname, String email, String password) async {
    try {
      final response = await createUserApi.createUserApi(
          firstname, lastname, email, password);
      //String message = response.data["message"] as String;
      return "ok";
    } on DioError catch (e) {
      final errorMessage =
          DioExceptions(e, "error : Something went wrong ! ").toString();
      throw errorMessage;
    }
  }
}
