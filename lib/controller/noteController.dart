import '../models/note.dart';
import '../network/repository/noteRepository.dart';
import '../service/serviceLocator.dart';
// import 'package:logging/logging.dart';


class NoteController {
  // --------------- Repository -------------
  final noteRepository = getIt.get<NoteRepository>();
  // final Logger log = Logger('NoteControllerLogger');

  // -------------- Methods ---------------
  Future<List<Note>> getAllNotes() async {
    final allNotes = await noteRepository.getNotesRequested();
    // log.info("allNotes: $allNotes");
    print("allNotes: $allNotes");
    return allNotes;
  }

  Future<List<Note>> getNotesByThreeDObjects(int threeDObjectId) async {
    final allNotesByThreeDObjects = await noteRepository.getNotesByThreeDObjectsRequested(threeDObjectId);
    // log.info("allNotesByThreeDObjects: $allNotesByThreeDObjects");
    print("allNotesByThreeDObjects: $allNotesByThreeDObjects");
    return allNotesByThreeDObjects;
  }

  Future<Note> addNewNote(String input , int id) async {
    final Note newNote = await noteRepository.addNote(input,id);
    return newNote;
  }

  Future<void> deleteNote( int id) async {
    await noteRepository.deleteNote(id);
  }
}
