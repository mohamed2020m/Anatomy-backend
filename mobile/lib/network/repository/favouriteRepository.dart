import 'package:TerraViva/models/Favourite.dart';
import 'package:dio/dio.dart';

import '../dioException.dart';
import '../api/favouriteApi.dart';

class FavouriteRepository {
  
  final FavouriteApi favouriteApi;
  
  FavouriteRepository(this.favouriteApi);
  
  Future<List<Favourite>> getAllFavourites() async {
    try {
      final response = await favouriteApi.fetchAllFavourites();
      print("response: $response.data");

      List<Favourite> allFavourites =
          (response.data as List).map((e) => Favourite.fromJson(e)).toList();

      return allFavourites;
      // ignore: deprecated_member_use
    } on DioError catch (e) {
      print("Error in getAllFavourites: $e");
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

}
