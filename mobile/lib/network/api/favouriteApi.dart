import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../Endpoints.dart';
import '../dioClient.dart';

class FavouriteApi {
  final DioClient dioClient;
  final storage = const FlutterSecureStorage();
  FavouriteApi({required this.dioClient});

  Future<Response> fetchAllFavourites() async {
    try {
      final token = await storage.read(key: "token");
      if (token == null) {
        throw Exception("Token is missing");
      }
      print("Using token: $token");

      final Response response = await dioClient.get(
        '${Endpoints.baseUrl}${Endpoints.favourite}', //endpoint called
        options: Options(
          headers: {
            "Authorization": 'Bearer $token'
          },
        ),
      );

      print("fetchAllFavourites Response: ${response.data}");
      return response;
    } catch (e) {
      print("Error in fetchAllFavourites: $e");
      rethrow;
    }
  }




  

}
