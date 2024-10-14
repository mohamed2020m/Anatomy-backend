
import 'package:my_app/models/Object3d.dart';
import '../models/Object3d.dart';
import '../network/repository/objectsParCategoryRepository.dart';
import '../service/serviceLocator.dart';

class ObjectsParCategoryController {
  // --------------- Repository -------------
  final objectsParCategoryRepository = getIt.get<ObjectsParCategoryRepository>();
  // -------------- Methods ---------------
  Future<List<Object3d>> getAllobjectsParCategory(int idCategory ) async {
    final allObjects = await objectsParCategoryRepository.getObjectsParCategoryRequested(idCategory);
    return allObjects;
  }
}
