import 'package:dio/dio.dart';

import '../../models/Category.dart';
import '../../models/Object3d.dart';
import '../api/SearchApi.dart';
import '../dioException.dart';

class SearchRepository {
  final SearchApi searchApi;
  SearchRepository(this.searchApi);
  Future<List> getAllSearchResult(String input) async {
    try {
      final response = await searchApi.searchApi(input);
      List allResult = [];
      print("##########################################");
      print(response.data);
      allResult.add((response.data['categories'] as List)
          .map((e) => Category.fromJson(e))
          .toList());
      allResult.add((response.data['objects'] as List)
          .map((e) => Object3d.fromJson(e))
          .toList());
      print(allResult);
      return allResult;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  Future<List<Category>> getSearchParCategoryResult(String input) async {
    try {
      final response = await searchApi.searchCategoryApi(input);
      List<Category> allCategory =
          (response.data as List).map((e) => Category.fromJson(e)).toList();
      return allCategory;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  Future<List<Object3d>> getSearchParObject3dResult(String input) async {
    try {
      final response = await searchApi.searchObject3dApi(input);
      List<Object3d> allCours =
          (response.data as List).map((e) => Object3d.fromJson(e)).toList();

      return allCours;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }
}
