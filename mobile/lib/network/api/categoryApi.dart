import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../Endpoints.dart';
import '../dioClient.dart';

class CategoryApi {
  final DioClient dioClient;
  final storage = const FlutterSecureStorage();
  CategoryApi({required this.dioClient});

  Future<Response> getCategoryApi() async {
    try {
      final token = await storage.read(key: "token");
      if (token == null) {
        throw Exception("Token is missing");
      }
      print("Using token: $token");

      final Response response = await dioClient.get(
        '${Endpoints.baseUrl}${Endpoints.category}/main',
        options: Options(
          headers: {
            "Authorization": 'Bearer $token'
          },
        ),
      );

      // print("getCategoryApi Response: ${response.data}");
      return response;
    } catch (e) {
      print("Error in getCategoryApi: $e");
      rethrow;
    }
  }

  Future<Response> getSubCategoryApi(int idCat) async {
    try {
      final token = await storage.read(key: "token");
      if (token == null) {
        throw Exception("Token is missing");
      }

      final Response response = await dioClient.get(
        '${Endpoints.baseUrl}${Endpoints.category}/$idCat/sub_categories',
        options: Options(
          headers: {
            "Authorization": 'Bearer $token'
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Future<Response> getCategoryApi() async {
  //   print(
  //       "##################################### token #########################################");
  //   print(await storage.read(key: "token"));
  //   try {
  //     final Response response = await dioClient.get(
  //       '${Endpoints.baseUrl}${Endpoints.category}',
  //       options: Options(
  //         headers: {
  //           "Authorization": 'Bearer ${await storage.read(key: "token")}'
  //           // "Authorization": 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJyb2xlcyI6WyJST0xFX0FETUlOIl0sInN1YiI6ImFkbWluQGFkbWluLmNvbSIsImlhdCI6MTczMjM4OTU4MiwiZXhwIjoxNzMyNDc1OTgyfQ.XqLf2H3IQsY3GVvMycAeQoDgujEvSs2vz6WorSmqJ1M'
  //         }
  //       )
  //     );

  //     print("getCategoryApi: ${response.data}");
  //     return response;
  //   } catch (e) {
  //     print("getCategoryApi: ${e}");
  //     rethrow;
  //   }
  // }

  Future<Response> getCategoryCount(int idCat) async {
    try {
      final token = await storage.read(key: "token");
      if (token == null) {
        throw Exception("Token is missing");
      }

      final Response response = await dioClient.get(
          '${Endpoints.baseUrl}${Endpoints.category}/$idCat/sub_categories/count',
          options: Options(headers: {
            "Authorization": 'Bearer $token'
          }));

      print("getCategoryCount: ${response.data}");
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getObject3dCountByCategory(int idCat) async {
    try {
      final token = await storage.read(key: "token");
      if (token == null) {
        throw Exception("Token is missing");
      }

      final Response response = await dioClient.get(
          '${Endpoints.baseUrl}${Endpoints.category}/$idCat/3d_objects/count',
          options: Options(headers: {
            "Authorization": 'Bearer $token'
          }));

      print("getObject3dCountByCategory: ${response.data}");
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
