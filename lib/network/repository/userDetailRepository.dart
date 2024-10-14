import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../models/user.dart';
import '../api/userDetailApi.dart';
import '../dioException.dart';

class UserDetailRepository {
  final UserDetailApi userDetail;
  UserDetailRepository(this.userDetail);
  Future<User> getUserRequested() async {
    try {
      final response = await userDetail.userDetailApi();
      User user = User.fromJson(response.data);
      print(response.data);
      return user;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }
}