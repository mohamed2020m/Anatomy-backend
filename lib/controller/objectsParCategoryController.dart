
import 'package:TerraViva/models/Object3d.dart';
import 'package:TerraViva/models/ThreeDObject.dart';
import '../network/repository/objectsParCategoryRepository.dart';
import '../service/serviceLocator.dart';

class ObjectsParCategoryController {
  // --------------- Repository -------------
  final objectsParCategoryRepository = getIt.get<ObjectsParCategoryRepository>();
  // -------------- Methods ---------------
  Future<List<ThreeDObject>> getAllobjectsParCategory(int idCategory ) async {
    final allObjects = await objectsParCategoryRepository.getObjectsParCategoryRequested(idCategory);
    return allObjects;
  }

  Future<List<ThreeDObject>> getLatestObject3D() async {
    final latestObject3D = await objectsParCategoryRepository.getLatestObject3D();
    return latestObject3D;
  }
}
