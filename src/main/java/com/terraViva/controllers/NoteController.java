package com.terraViva.controllers;

import com.terraViva.dto.NoteDTO;
import com.terraViva.services.implementations.NoteServiceImpl;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/notes")
@CrossOrigin("*")
public class NoteController {
    private NoteServiceImpl noteService;

    public  NoteController( NoteServiceImpl  noteService) {
        this. noteService =  noteService;
    }

    @PostMapping
    public ResponseEntity<NoteDTO> saveNote(@RequestBody NoteDTO noteDTO) {
        return ResponseEntity.ok(noteService.saveNote(noteDTO));
    }

    @GetMapping("/{id}")
    public ResponseEntity<NoteDTO> getNoteById(@PathVariable Long id){
        return ResponseEntity.ok(noteService.getNoteById(id));
    }

    @GetMapping("/student/{studentId}")
    public ResponseEntity<List<NoteDTO>> getNotesByStudent(@PathVariable Long studentId){
        return ResponseEntity.ok(noteService.getNotesByStudent(studentId));
    }

    @GetMapping
    public ResponseEntity<List<NoteDTO>> getAllNotes() {
        return ResponseEntity.ok(noteService.getAllNotes());
    }


    @PutMapping("/{id}")
    public ResponseEntity<NoteDTO> updateNote(@PathVariable Long id, @RequestBody NoteDTO noteDTO) {
        noteDTO.setId(id);
        NoteDTO updatedNote = noteService.updateNote(noteDTO);
        return ResponseEntity.ok(updatedNote);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<String> deleteNote(@PathVariable Long id){
        noteService.deleteNote(id);
        return new ResponseEntity("Note deleted successfully", HttpStatus.OK);
    }
}
