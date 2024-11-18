package com.terraViva.services.interfaces;

import com.terraViva.dto.StudentDTO;
import com.terraViva.exceptions.UserNotFoundException;

import java.util.List;


public interface StudentService {
    
    StudentDTO saveStudent(StudentDTO studentDTO);

    StudentDTO getStudentById(Long studentId) throws UserNotFoundException;

    List<StudentDTO> getAllStudents();

    StudentDTO updateStudent(StudentDTO studentDTO)throws UserNotFoundException;

    void deleteStudent(Long studentId) throws UserNotFoundException;

    StudentDTO getStudentInfo(String username);

    Long getStudentsCount();
}
