package com.med3dexplorer.mapper;


import com.med3dexplorer.dto.NoteDTO;
import com.med3dexplorer.models.Note;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class NoteDTOConverter {


    @Autowired
    private ModelMapper modelMapper;

    public Note toEntity(NoteDTO noteDTO) {
        Note note = modelMapper.map(noteDTO, Note.class);
        return note;
    }

    public  NoteDTO toDto(Note note) {
        NoteDTO noteDTO =modelMapper.map(note,NoteDTO.class);
        return noteDTO;
    }

}
