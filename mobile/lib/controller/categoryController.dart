import '../models/Category.dart';
import '../network/repository/categoryRepository.dart';
import '../service/serviceLocator.dart';

class CategoryController {
  // --------------- Repository -------------
  final userRepository = getIt.get<CategoryRepository>();
  // -------------- Methods ---------------
  Future<List<Category>> getAllCategory() async {
    final allCategory = await userRepository.getCategoryRequested();
    print("allCategory: $allCategory");
    return allCategory;
  }

  Future<List<Category>> getSubCategories(int idCat) async {
    final subCategories = await userRepository.getSubCategoryRequested(idCat);
    print("subCategories: $subCategories");
    return subCategories;
  }

  Future<int> getCategoryCount(int idCat) async {
    final totale = await userRepository.getCategoryCount(idCat);
    return totale;
  }

  Future<int> getObject3dCountByCategory(int idCat) async {
    final totale = await userRepository.getObject3dCountByCategory(idCat);
    return totale;
  }
}
