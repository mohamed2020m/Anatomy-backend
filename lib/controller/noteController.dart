import '../models/note.dart';
import '../network/repository/noteRepository.dart';
import '../service/serviceLocator.dart';

class NoteController {
  // --------------- Repository -------------
  final noteRepository = getIt.get<NoteRepository>();
  // -------------- Methods ---------------
  Future<List<Note>> getAllNotes(int id) async {
    final allNotes = await noteRepository.getNotesRequested(id);
    return allNotes;
  }

  Future<Note> addNewNote(String input , int id) async {
    final Note newNote = await noteRepository.addNote(input,id);
    return newNote;
  }
  Future<void> deleteNote( int id) async {
    await noteRepository.deleteNote(id);
  }
}
