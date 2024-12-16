import '../network/repository/loginRepository.dart';
import '../service/serviceLocator.dart';

class LoginController {
  // --------------- Repository -------------
  final loginRepository = getIt.get<LogInRepository>();
  // -------------- Methods ---------------
  Future login(String email, String password) async {
    final user = await loginRepository.getUserRequested(email, password);
    print("user: $user");
    return user;
  }
}
