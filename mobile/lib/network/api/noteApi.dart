import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../Endpoints.dart';
import '../dioClient.dart';

class NoteApi {
  final DioClient dioClient;
  final storage = const FlutterSecureStorage();
  NoteApi({required this.dioClient});
  Future<Response> getNotes() async {
    try {
      final token = await storage.read(key: "token");
      final userId = await storage.read(key: "user_id");
      if (token == null) {
        throw Exception("Token is missing");
      }
      if (userId == null) {
        throw Exception("UserID is missing");
      }

      final Response response = await dioClient.get(
        "${Endpoints.baseUrl}${Endpoints.note}/student/$userId",
        options: Options(headers: {
          "Authorization": 'Bearer $token'
        })
      );

      print("getNotes Response: ${response.data}");
      return response;
    } catch (e) {
      print("Error in getNotes: $e");
      rethrow;
    }
  }


  Future<Response> getNotesByThreeDObjects(int threeDObjectId) async {
    try {
      final token = await storage.read(key: "token");
      final userId = await storage.read(key: "user_id");
      if (token == null) {
        throw Exception("Token is missing");
      }
      if (userId == null) {
        throw Exception("userId is missing");
      }
      final Response response = await dioClient.get(
        "${Endpoints.baseUrl}${Endpoints.threeDObjects}/$threeDObjectId/student/$userId/notes",
        options: Options(headers: {
          "Authorization": 'Bearer $token'
        })
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> addNote(String content, int idObject3d) async {
    try {
      final token = await storage.read(key: "token");
      final userId = await storage.read(key: "user_id");
      if (token == null) {
        throw Exception("Token is missing");
      }
      if (userId == null) {
        throw Exception("userId is missing");
      }
      final Response response = await dioClient.post(
          "${Endpoints.baseUrl}${Endpoints.note}",
          data: {
            "student": {"id": userId},
            "threeDObject": {"id": idObject3d},
            "content": content
          },
          options: Options(headers: {
            "Authorization": 'Bearer $token'
          }));
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteNote(int noteId) async {
    try {
      final token = await storage.read(key: "token");
      if (token == null) {
        throw Exception("Token is missing");
      }

      print("noteId: $noteId");
      print("${Endpoints.baseUrl}${Endpoints.note}/$noteId");
      await dioClient.delete(
          "${Endpoints.baseUrl}${Endpoints.note}/$noteId",
          options: Options(headers: {
            "Authorization": 'Bearer $token'
          }));
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getNoteById(int id) async {
    try {
      final token = await storage.read(key: "token");
      if (token == null) {
        throw Exception("Token is missing");
      }
      final Response response = await dioClient.get(
        "${Endpoints.baseUrl}${Endpoints.note}/$id",
        options: Options(headers: {
          "Authorization": 'Bearer $token'
        })
      );
      return response;
    } catch (e) {
      print("e_getNotebyId: $e");
      rethrow;
    }
  }

}
