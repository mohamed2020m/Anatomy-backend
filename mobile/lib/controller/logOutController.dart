import '../network/repository/logoutRepository.dart';
import '../service/serviceLocator.dart';

class LogoutController {
  // --------------- Repository -------------
  final logOut = getIt.get<LogOutRepository>();
  // -------------- Methods ---------------
  Future logout() async {
    final res = await logOut.logout();
    return res;
  }
}
