import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../Endpoints.dart';
import '../dioClient.dart';

class ThreedObjectApi {
  final DioClient dioClient;
  final storage = const FlutterSecureStorage();
  
  ThreedObjectApi({required this.dioClient});


  Future<Response> getMyFavoriteObjects() async {
    try {
      final token = await storage.read(key: "token");
      if (token == null) {
        throw Exception("Token is missing");
      }

      final Response response = await dioClient.get(
        '${Endpoints.baseUrl}${Endpoints.threeDObjects}',
        options: Options(headers: {
          "Authorization": 'Bearer $token'
        }
      ));

      print("getMyFavoriteObjects Response: ${response.data}");
      return response;
    } catch (e) {
      print("Error in getMyFavoriteObjects: $e");
      rethrow;
    }
  }

  Future<Response> get3DObjectsByStudent() async {
    try {
        
        final token = await storage.read(key: "token");
        final userId = await storage.read(key: "user_id");
        if (token == null || userId == null) {
          throw Exception("Token or User ID is missing");
        }

      final Response response = await dioClient.get(
        '${Endpoints.baseUrl}${Endpoints.favourite}/$userId/my-favourites',
        options: Options(headers: {
          "Authorization": 'Bearer $token'
        }
      ));

      print("get3DObjectsByStudent Response: ${response.data}");
      return response;
    } catch (e) {
      print("Error in get3DObjectsByStudent: $e");
      rethrow;
    }
  }
  
  Future<Response> getLatestObject3D() async {
    try {
      final token = await storage.read(key: "token");
      if (token == null) {
        throw Exception("Token is missing");
      }

      final Response response = await dioClient.get(
        '${Endpoints.baseUrl}${Endpoints.threeDObjects}/last-five',
        options: Options(headers: {
          "Authorization": 'Bearer $token'
        }
      ));

      print("getLatestObject3D Response: ${response.data}");
      return response;
    } catch (e) {
      print("Error in getLatestObject3D: $e");
      rethrow;
    }
  }

  
  Future<Response> addToFavourites(String objectId) async { 
      try {
        final token = await storage.read(key: "token");
        final userId = await storage.read(key: "user_id");
        if (token == null || userId == null) {
          throw Exception("Token or User ID is missing");
        }
        //print("Using token: $token");
       // print("Using userId: $userId");

        final Response response = await dioClient.post(
          '${Endpoints.baseUrl}${Endpoints.favourite}/$objectId/student/$userId', //endpoint called
          options: Options(
            headers: {
              "Authorization": 'Bearer $token'
            },
          ),
        );

        print("addToFavourite Response: ${response.data}");
        return response;
      } catch (e) {
        print("Error in addToFavourite: $e");
        rethrow;
      }
  }

  Future<Response> removeFromFavorites(String objectId) async { 
      try {
        final token = await storage.read(key: "token");
        final userId = await storage.read(key: "user_id");
        if (token == null || userId == null) {
          throw Exception("Token or User ID is missing");
        }
        //print("Using token: $token");
       // print("Using userId: $userId");

        final Response response = await dioClient.delete(
          '${Endpoints.baseUrl}${Endpoints.favourite}/$objectId/student/$userId', //endpoint called
          options: Options(
            headers: {
              "Authorization": 'Bearer $token'
            },
          ),
        );

        print("deleteFavorite Response: ${response.data}");
        return response;
      } catch (e) {
        print("Error in deleteFavorite: $e");
        rethrow;
      }
  }

}
