import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../Endpoints.dart';
import '../dioClient.dart';

class SearchApi {
  final DioClient dioClient;
  SearchApi({required this.dioClient});
  final storage = const FlutterSecureStorage();
  Future<Response> searchApi(String input) async {
    try {
      final Response response = await dioClient.get(
          '${Endpoints.baseUrl}${Endpoints.search}',
          queryParameters: {"name": input},
          options: Options(headers: {
            "Authorization": 'Bearer ${await storage.read(key: "token")}'
          }));
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> searchCategoryApi(String input) async {
    try {
      final Response response = await dioClient.get(
          '${Endpoints.baseUrl}${Endpoints.searchByCategory}',
          queryParameters: {"name": input},
          options: Options(headers: {
            "Authorization": 'Bearer ${await storage.read(key: "token")}'
          }));
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> searchObject3dApi(String input) async {
    try {
      final Response response = await dioClient.get(
          '${Endpoints.baseUrl}${Endpoints.searchByObject3d}',
          queryParameters: {"name": input},
          options: Options(headers: {
            "Authorization": 'Bearer ${await storage.read(key: "token")}'
          }));
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
