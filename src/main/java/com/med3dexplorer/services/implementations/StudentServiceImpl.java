package com.med3dexplorer.services.implementations;

import com.med3dexplorer.dto.StudentDTO;
import com.med3dexplorer.dto.ThreeDObjectDTO;
import com.med3dexplorer.exceptions.ThreeDObjectNotFoundException;
import com.med3dexplorer.exceptions.UserNotFoundException;
import com.med3dexplorer.mapper.StudentDTOConverter;
import com.med3dexplorer.models.Administrator;
import com.med3dexplorer.models.Student;
import com.med3dexplorer.models.ThreeDObject;
import com.med3dexplorer.repositories.StudentRepository;
import com.med3dexplorer.services.interfaces.StudentService;
import jakarta.transaction.Transactional;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class StudentServiceImpl implements StudentService {

    private final StudentDTOConverter  studentDTOConverter;
    private StudentRepository studentRepository;
    private PasswordEncoder passwordEncoder;


    public StudentServiceImpl(PasswordEncoder passwordEncoder,StudentRepository studentRepository, StudentDTOConverter studentDTOConverter) {
        this.studentDTOConverter = studentDTOConverter;
        this.studentRepository = studentRepository;
        this.passwordEncoder = passwordEncoder;
    }


    @Override
    public StudentDTO saveStudent(StudentDTO studentDTO){
        Student student=studentDTOConverter.toEntity(studentDTO);
        StudentDTO savedStudent =studentDTOConverter.toDto(studentRepository.save(student));
        return savedStudent;
    }

    @Override
    public StudentDTO getStudentById(Long studentId) throws UserNotFoundException {
        Student student = studentRepository.findById(studentId).orElseThrow(() -> new UserNotFoundException("Student not found"));
        StudentDTO studentDTO = studentDTOConverter.toDto(student);
        return studentDTO;
    }

    @Override
    public List<StudentDTO> getAllStudents() {
        List<Student> students = studentRepository.findAll();
        List<StudentDTO> studentDTOs = students.stream().map(student -> studentDTOConverter.toDto(student)).collect(Collectors.toList());
        return studentDTOs;
    }

    @Override
    public StudentDTO updateStudent(StudentDTO studentDTO) throws UserNotFoundException {
        Student existingStudent = studentRepository.findById(studentDTO.getId())
                .orElseThrow(() -> new UserNotFoundException("Student not found with id: " + studentDTO.getId()));
        if (studentDTO.getEmail() != null) {
            existingStudent.setEmail(studentDTO.getEmail());
        }
        if (studentDTO.getFirstName() != null) {
            existingStudent.setFirstName(studentDTO.getFirstName());
        }

        if (studentDTO.getLastName() != null) {
            existingStudent.setLastName(studentDTO.getLastName());
        }
        if (studentDTO.getPassword() != null) {
            existingStudent.setPassword(passwordEncoder.encode(studentDTO.getPassword()));
        }
        if (studentDTO.getCreatedAt() != null) {
            existingStudent.setCreatedAt(studentDTO.getCreatedAt());
        }

        existingStudent.setUpdatedAt(LocalDateTime.now());
        Student updatedStudent = studentRepository.save(existingStudent);
        return studentDTOConverter.toDto(updatedStudent);
    }



    @Override
    public void deleteStudent(Long studentId) throws UserNotFoundException {
        Student student=studentRepository.findById(studentId).orElseThrow(() -> new UserNotFoundException("Student not found"));
        studentRepository.delete(student);
    }

    @Override
    public StudentDTO getStudentInfo(String username) throws UserNotFoundException {
        Student administrator = studentRepository.findByEmail(username)
                .orElseThrow(() -> new UserNotFoundException("Student not found"));

        return studentDTOConverter.toDto(administrator);
    }
}
