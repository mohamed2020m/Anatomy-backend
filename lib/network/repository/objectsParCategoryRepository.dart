import 'package:dio/dio.dart';
import '../../models/Object3d.dart';
import '../api/categoryApi.dart';
import '../api/objectsParCategoryApi.dart';
import '../dioException.dart';

class ObjectsParCategoryRepository {
  final ObjectsParCategoryApi objectsParCategoryApi;

  ObjectsParCategoryRepository(this.objectsParCategoryApi);
  Future<List<Object3d>> getObjectsParCategoryRequested(int idCategory) async {
    try {
      final response =
          await objectsParCategoryApi.getobjectsParCategoryApi(idCategory);
      List<Object3d> allObjects = (response.data as List).map((e) => Object3d.fromJson(e)).toList();
      return allObjects;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  // Future<Cours> getCoursParIdRequested() async {
  //   try {
  //     final response = await coursParCategoryApi.getCoursParIdApi();
  //     print(response.data);
  //     Cours cours = Cours.fromJson(response.data);
  //     return cours;
  //   } on DioError catch (e) {
  //     final errorMessage = DioExceptions.fromDioError(e).toString();
  //     throw errorMessage;
  //   }
  // }

  // Future<Category> getCategoryParIdRequested() async {
  //   try {
  //     final response = await categoryApi.getCategoryParIdApi();

  //     Category allCategory = Category.fromJson(response.data);

  //     return allCategory;
  //   } on DioError catch (e) {
  //     final errorMessage = DioExceptions.fromDioError(e).toString();
  //     throw errorMessage;
  //   }
  // }
}
