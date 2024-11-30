import 'package:dio/dio.dart';
import '../../models/ThreeDObject.dart';
import '../dioException.dart';
import '../api/threeDObjectApi.dart';

class ThreeDObjectRepository {
  
  final ThreedObjectApi threeDObjectApi;
  
  ThreeDObjectRepository(this.threeDObjectApi);
  
  Future<List<ThreeDObject>> getMyFavoriteObjects() async {
    try {
      final response = await threeDObjectApi.getMyFavoriteObjects();
      print("response: $response.data");

      List<ThreeDObject> allObjects =
          (response.data as List).map((e) => ThreeDObject.fromJson(e)).toList();

      return allObjects;
      // ignore: deprecated_member_use
    } on DioError catch (e) {
      print("Error in getAllQuizzes: $e");
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  Future<List<ThreeDObject>> getLatestObject3D() async {
    try {
      final response =
          await threeDObjectApi.getLatestObject3D();
      List<ThreeDObject> allObjects = (response.data as List).map((e) => ThreeDObject.fromJson(e)).toList();
      return allObjects;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  Future<List<ThreeDObject>> get3DObjectsByStudent() async {
    try {
      final response =
          await threeDObjectApi.get3DObjectsByStudent();
      List<ThreeDObject> allObjects = (response.data as List).map((e) => ThreeDObject.fromJson(e)).toList();
      return allObjects;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  Future<void> addToFavourites(String objectId) async {
    try {
      final response = await threeDObjectApi.addToFavourites(objectId);
      
      // Check if the response status is 200 (success)
      if (response.statusCode != 200) {
        throw Exception(
            "Failed to save 3D Object to Favorite. Status code: ${response.statusCode}");
      }

    print("Favorite successfully saved for Object: $objectId!");
    
      // ignore: deprecated_member_use
    } on DioError catch (e) {
      print("Error in addToFavourite: $e");
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }


  Future<void> removeFromFavorites(String objectId) async {
    try {
      final response = await threeDObjectApi.removeFromFavorites(objectId);
      
      // Check if the response status is 200 (success)
      if (response.statusCode != 200) {
        throw Exception(
            "Failed to delete 3D Object from Favorite. Status code: ${response.statusCode}");
      }

    print("Favorite successfully deleted!");
    
      // ignore: deprecated_member_use
    } on DioError catch (e) {
      print("Error in deleteFavorite: $e");
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }



}
