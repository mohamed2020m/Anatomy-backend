import '../models/Category.dart';
import '../network/repository/categoryRepository.dart';
import '../service/serviceLocator.dart';

class CategoryController {
  // --------------- Repository -------------
  final userRepository = getIt.get<CategoryRepository>();
  // -------------- Methods ---------------
  Future<List<Category>> getAllCategory() async {
    final allCategory = await userRepository.getCategoryRequested();
    return allCategory;
  }

  Future<int> getCategoryCount(int idCat) async {
    final totale = await userRepository.getCategoryCount(idCat);
    return totale;
  }
}
