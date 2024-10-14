import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../Endpoints.dart';
import '../dioClient.dart';

class CategoryApi {
  final DioClient dioClient;
  final storage = const FlutterSecureStorage();
  CategoryApi({required this.dioClient});
  Future<Response> getCategoryApi() async {
    print(
        "##############################################################################");
    print(await storage.read(key: "token"));
    try {
      final Response response = await dioClient.get(
          '${Endpoints.baseUrl}${Endpoints.category}',
          options: Options(headers: {
            "Authorization": 'Bearer ${await storage.read(key: "token")}'
          }));
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getCategoryCount(int idCat) async {
    try {
      final Response response = await dioClient.get(
          '${Endpoints.baseUrl}${Endpoints.category}/objs/${idCat}',
          options: Options(headers: {
            "Authorization": 'Bearer ${await storage.read(key: "token")}'
          }));
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
