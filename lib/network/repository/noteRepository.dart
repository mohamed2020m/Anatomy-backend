import 'package:dio/dio.dart';

import '../../models/note.dart';
import '../api/noteApi.dart';
import '../dioException.dart';

class NoteRepository {
  final NoteApi noteApi;
  NoteRepository(this.noteApi);
  Future<List<Note>> getNotesRequested(int id) async {
    try {
      final response = await noteApi.getNotes(id);
      List<Note> allNotes =
          (response.data as List).map((e) => Note.fromJson(e)).toList();
      return allNotes;
      // ignore: deprecated_member_use
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  Future<Note> addNote(String input, int id) async {
    try {
      final response = await noteApi.addNote(input, id);
      Note newNote = Note.fromJson(response.data);
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
