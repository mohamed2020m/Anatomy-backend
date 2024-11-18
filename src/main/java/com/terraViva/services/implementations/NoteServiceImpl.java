package com.terraViva.services.implementations;


import com.terraViva.dto.NoteDTO;
import com.terraViva.exceptions.NoteNotFoundException;
import com.terraViva.mapper.NoteDTOConverter;
import com.terraViva.models.Note;
import com.terraViva.repositories.NoteRepository;
import com.terraViva.services.interfaces.NoteService;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional

public class NoteServiceImpl implements NoteService{

    private final NoteDTOConverter  noteDTOConverter;
    private NoteRepository  noteRepository;


    public NoteServiceImpl(NoteRepository noteRepository, NoteDTOConverter noteDTOConverter) {
        this.noteDTOConverter = noteDTOConverter;
        this.noteRepository = noteRepository;
    }


    @Override
    public NoteDTO saveNote(NoteDTO noteDTO){
        Note note=noteDTOConverter.toEntity(noteDTO);
        note.setCreatedAt(LocalDateTime.now());
        NoteDTO savedNote =noteDTOConverter.toDto(noteRepository.save(note));
        return savedNote;
    }

    @Override
    public NoteDTO getNoteById(Long noteId) throws NoteNotFoundException {
        Note note = noteRepository.findById(noteId).orElseThrow(() -> new NoteNotFoundException("Note not found"));
        NoteDTO noteDTO = noteDTOConverter.toDto(note);
        return noteDTO;
    }

    @Override
    public List<NoteDTO> getAllNotes() {
        List<Note> notes = noteRepository.findAll();
        List<NoteDTO> noteDTOs = notes.stream().map(note -> noteDTOConverter.toDto(note)).collect(Collectors.toList());
        return noteDTOs;
    }

    @Override
    public NoteDTO updateNote(NoteDTO noteDTO) throws NoteNotFoundException {
        Note existingNote = noteRepository.findById(noteDTO.getId())
                .orElseThrow(() -> new NoteNotFoundException("Note not found with id: " + noteDTO.getId()));
        if (noteDTO.getContent() != null) {
            existingNote.setContent(noteDTO.getContent());
        }
        existingNote.setUpdatedAt(LocalDateTime.now());
        Note updatedNote = noteRepository.save(existingNote);
        return noteDTOConverter.toDto(updatedNote);
    }


    @Override
    public void deleteNote(Long noteId) throws NoteNotFoundException {
        Note note=noteRepository.findById(noteId).orElseThrow(() -> new NoteNotFoundException("Note not found"));
        noteRepository.delete(note);
    }


}
