

import '../network/repository/createUserRepository.dart';
import '../service/serviceLocator.dart';

class CreateUserController {
  final craeteUser = getIt.get<CreateUserRepository>();

  // -------------- Methods ---------------
  Future<String> createuser(String firstname, String lastname, String email, String password) async {
    final res = await craeteUser.getmessage(firstname, lastname, email, password);
    return res;
  }
}
