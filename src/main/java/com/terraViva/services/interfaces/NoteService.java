package com.terraViva.services.interfaces;

import com.terraViva.dto.NoteDTO;
import com.terraViva.exceptions.NoteNotFoundException;

import java.util.List;

public interface NoteService {

    NoteDTO saveNote(NoteDTO noteDTO);

    NoteDTO getNoteById(Long noteId) throws NoteNotFoundException;

    List<NoteDTO> getAllNotes();

    NoteDTO updateNote(NoteDTO noteDTO)throws NoteNotFoundException;

    void deleteNote(Long noteId) throws NoteNotFoundException;


}
