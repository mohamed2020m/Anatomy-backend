import 'package:dio/dio.dart';

import '../../models/Category.dart';
import '../dioException.dart';
import '../api/categoryApi.dart';

class CategoryRepository {
  final CategoryApi categoryApi;
  CategoryRepository(this.categoryApi);
  Future<List<Category>> getCategoryRequested() async {
    try {
      final response = await categoryApi.getCategoryApi();
      print("response: $response.data");

      List<Category> allCategory =
          (response.data as List).map((e) => Category.fromJson(e)).toList();

      return allCategory;
      // ignore: deprecated_member_use
    } on DioError catch (e) {
      print("Error in getCategoryRequested: $e");
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }


  Future<List<Category>> getSubCategoryRequested(int idCat) async {
    try {
      final response = await categoryApi.getSubCategoryApi(idCat);
      print("response: $response.data");

      List<Category> allCategory =
          (response.data as List).map((e) => Category.fromJson(e)).toList();

      return allCategory;
      // ignore: deprecated_member_use
    } on DioError catch (e) {
      print("Error in getCategoryRequested: $e");
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  Future<int> getCategoryCount(int idCat) async {
    try {
      final response = await categoryApi.getCategoryCount(idCat);
      print("response: $response.data");

      int total = response.data["total"];
      print("total: $total");
      return total;
      // ignore: deprecated_member_use
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  Future<int> getObject3dCountByCategory(int idCat) async {
    try {
      final response = await categoryApi.getObject3dCountByCategory(idCat);
      print("response: $response.data");
      
      int total = response.data["total"];
      print("total: $total");
      return total;
      // ignore: deprecated_member_use
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }
}
