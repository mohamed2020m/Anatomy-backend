import '../models/ThreeDObject.dart';
import '../network/repository/threeDObjectRepository.dart';
import '../service/serviceLocator.dart';

class ThreeDObjectController {

  final threeDObjectRepository = getIt.get<ThreeDObjectRepository>();

  Future<List<ThreeDObject>> getLatestObject3D() async {
    final latestObject3D = await threeDObjectRepository.getLatestObject3D();
    return latestObject3D;
  }

  Future<List<ThreeDObject>> get3DObjectsByStudent() async {
    final latestObject3D = await threeDObjectRepository.get3DObjectsByStudent();
    return latestObject3D;
  }

  Future<void> addToFavourites(String objectId) async {
    await threeDObjectRepository.addToFavourites(objectId);
  }

  Future<void> removeFromFavorites(String objectId) async {
    await threeDObjectRepository.removeFromFavorites(objectId);
  }

}
