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

      List<Category> allCategory =
          (response.data as List).map((e) => Category.fromJson(e)).toList();

      return allCategory;
      // ignore: deprecated_member_use
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  Future<int> getCategoryCount(int idCat) async {
    try {
      final response = await categoryApi.getCategoryCount(idCat);

      int totale = response.data["totale"];

      return totale;
      // ignore: deprecated_member_use
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }
}
