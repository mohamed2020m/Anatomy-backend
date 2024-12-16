package com.terraViva.mapper;

import com.terraViva.dto.StudentDTO;
import com.terraViva.models.Student;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class StudentDTOConverter {


    @Autowired
    private ModelMapper modelMapper;

    public  Student toEntity( StudentDTO  studentsDTO) {
         Student  student = modelMapper.map( studentsDTO,  Student.class);
        return  student;
    }

    public  StudentDTO toDto( Student  students) {
         StudentDTO  studentsDTO =modelMapper.map( students,  StudentDTO.class);
        return  studentsDTO;
    }

}
