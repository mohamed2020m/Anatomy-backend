import '../models/Favourite.dart';
import '../network/repository/favouriteRepository.dart';
import '../service/serviceLocator.dart';

class FavouriteController {

  final favouriteRepository = getIt.get<FavouriteRepository>();

  Future<List<Favourite>> getAllFavourites() async {
    final allFavourites = await favouriteRepository.getAllFavourites();
    print("allFavourites: $allFavourites");
    return allFavourites;
  }


}
