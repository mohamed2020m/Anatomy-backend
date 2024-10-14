import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../Endpoints.dart';
import '../dioClient.dart';

class NoteApi {
  final DioClient dioClient;
  final storage = const FlutterSecureStorage();
  NoteApi({required this.dioClient});
  Future<Response> getNotes(int id) async {
    try {
      final Response response = await dioClient.get(
          Endpoints.baseUrl + Endpoints.object3d + id.toString() + "/notes",
          options: Options(headers: {
            "Authorization": 'Bearer ${await storage.read(key: "token")}'
          }));
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> addNote(String input, int idObject3d) async {
    try {
      final Response response = await dioClient.post(
          Endpoints.baseUrl + Endpoints.note + "add",
          data: {
            "user": {"id": await storage.read(key: "id")},
            "objet": {"id": idObject3d},
            "content": input
          },
          options: Options(headers: {
            "Authorization": 'Bearer ${await storage.read(key: "token")}'
          }));
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteNote(int noteId) async {
    try {
      await dioClient.delete(
          Endpoints.baseUrl + Endpoints.note + "delete/" + noteId.toString(),
          options: Options(headers: {
            "Authorization": 'Bearer ${await storage.read(key: "token")}'
          }));
    } catch (e) {
      rethrow;
    }
  }
}
