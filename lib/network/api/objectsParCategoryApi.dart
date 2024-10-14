import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../Endpoints.dart';
import '../dioClient.dart';

class ObjectsParCategoryApi {
  final DioClient dioClient;
  final storage = const FlutterSecureStorage();

  ObjectsParCategoryApi({required this.dioClient});
  Future<Response> getobjectsParCategoryApi(int idCategory) async {
    try {
      final Response response = await dioClient.get(
          '${Endpoints.baseUrl}${Endpoints.category}/${idCategory}/objects',
          options: Options(headers: {
            "Authorization": 'Bearer ${await storage.read(key: "token")}'
          }));
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
