import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../Endpoints.dart';
import '../dioClient.dart';

// class LogOutApi {
//   final DioClient dioClient;
//   final storage = const FlutterSecureStorage();
//   LogOutApi({required this.dioClient});
//   Future<Response> logOutApi() async {
//     try {
//       final Response response = await dioClient.post(Endpoints.logout,
//           options: Options(headers: {
//             "Authorization": 'Bearer ${await storage.read(key: "token")}'
//           }));
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }
// }


class LogOutApi {
  final storage = const FlutterSecureStorage();

  // Method to delete the token from storage
  Future<void> logOut() async {
    try {
      // Remove the token from secure storage
      await storage.delete(key: "token");
      print("Token deleted successfully");
    } catch (e) {
      // Handle errors if needed
      print("Error deleting token: $e");
      rethrow;
    }
  }
}
