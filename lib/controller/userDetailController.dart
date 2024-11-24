import '../models/user.dart';
import '../network/repository/userDetailRepository.dart';
import '../service/serviceLocator.dart';

class UserDetailController {
  // --------------- Repository -------------
  final userInfo = getIt.get<UserDetailRepository>();
  // -------------- Methods ---------------
  Future<User> getUserInfo() async {
    final user = await userInfo.getUserRequested();
    return user;
  }

  Future<String> updateUserInfo(String firstName, String lastName) async {
    final user = await userInfo.updateUserRequested(firstName, lastName);
    return user;
  }
}
