package com.med3dexplorer.services.interfaces;

import com.med3dexplorer.dto.StudentDTO;
import com.med3dexplorer.exceptions.UserNotFoundException;

import java.util.List;


public interface StudentService {
    
    StudentDTO saveStudent(StudentDTO studentDTO);

    StudentDTO getStudentById(Long studentId) throws UserNotFoundException;

    List<StudentDTO> getAllStudents();

    StudentDTO updateStudent(StudentDTO studentDTO)throws UserNotFoundException;

    void deleteStudent(Long studentId) throws UserNotFoundException;
}
