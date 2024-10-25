package com.med3dexplorer.services.interfaces;

import com.med3dexplorer.dto.NoteDTO;
import com.med3dexplorer.exceptions.NoteNotFoundException;

import java.util.List;

public interface NoteService {

    NoteDTO saveNote(NoteDTO noteDTO);

    NoteDTO getNoteById(Long noteId) throws NoteNotFoundException;

    List<NoteDTO> getAllNotes();

    NoteDTO updateNote(NoteDTO noteDTO)throws NoteNotFoundException;

    void deleteNote(Long noteId) throws NoteNotFoundException;


}
