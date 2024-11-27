import 'package:dio/dio.dart';

import '../../models/note.dart';
import '../api/noteApi.dart';
import '../dioException.dart';

class NoteRepository {
  final NoteApi noteApi;
  NoteRepository(this.noteApi);

  Future<List<Note>> getNotesRequested() async {
    try {
      final response = await noteApi.getNotes();
      List<Note> allNotes =
          (response.data as List).map((e) => Note.fromJson(e)).toList();
      return allNotes;
      // ignore: deprecated_member_use
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  // Future<Note> getNoteById(int id) async {
  //   try {
  //     final response = await noteApi.getNoteById(id);
  //     Note note = Note.fromJson(response.data) ;
  //     return note;
  //     // ignore: deprecated_member_use
  //   } on DioError catch (e) {
  //     final errorMessage = DioExceptions.fromDioError(e).toString();
  //     throw errorMessage;
  //   }
  // }

  Future<List<Note>> getNotesByThreeDObjectsRequested(int threeDObjectId) async {
    try {
      final response = await noteApi.getNotesByThreeDObjects(threeDObjectId);
      List<Note> notesByThreeDObjects =
          (response.data as List).map((e) => Note.fromJson(e)).toList();
      return notesByThreeDObjects;
      // ignore: deprecated_member_use
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  Future<Note> addNote(String content, int threeDObjectId) async {
    try {
      final response = await noteApi.addNote(content, threeDObjectId);
      final noteId = response.data['id'];
      final res2 = await noteApi.getNoteById(noteId);
      Note newNote = Note.fromJson(res2.data);
      return newNote;
      // ignore: deprecated_member_use
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }
  Future<void> deleteNote(int id) async {
    try {
      await noteApi.deleteNote(id);
      // ignore: deprecated_member_use
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }
}
