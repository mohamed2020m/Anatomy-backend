package com.terraViva.services.implementations;

import com.terraViva.dto.CategoryStudentCountDTO;
import com.terraViva.dto.StudentDTO;
import com.terraViva.exceptions.UserNotFoundException;
import com.terraViva.mapper.StudentDTOConverter;
import com.terraViva.models.Category;
import com.terraViva.models.Professor;
import com.terraViva.models.Student;
import com.terraViva.repositories.ProfessorRepository;
import com.terraViva.repositories.StudentRepository;
import com.terraViva.services.interfaces.StudentService;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

@Service
@Transactional
public class StudentServiceImpl implements StudentService {

    private final StudentDTOConverter  studentDTOConverter;
    private final ProfessorRepository professorRepository;
    private StudentRepository studentRepository;


    public StudentServiceImpl(StudentRepository studentRepository, StudentDTOConverter studentDTOConverter, ProfessorRepository professorRepository) {
        this.studentDTOConverter = studentDTOConverter;
        this.studentRepository = studentRepository;
        this.professorRepository = professorRepository;
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
        Student updatedStudent = studentRepository.save(studentDTOConverter.toEntity(studentDTO));
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

    public List<StudentDTO> getStudentsByProfessorCategory(Long professorId) {
        Optional<Professor> professor = professorRepository.findById(professorId);
        if (professor.isPresent() && professor.get().getCategory() != null) {
            Long categoryId = professor.get().getCategory().getId();
            List<Student> students = studentRepository.findByCategoryId(categoryId);
            List<StudentDTO> studentDTOs = students.stream().map(student -> studentDTOConverter.toDto(student)).collect(Collectors.toList());
            return studentDTOs;
        } else {
            throw new RuntimeException("Professor or associated category not found");
        }
    }

    @Override
    public Long getStudentsCount() {
        return studentRepository.count();
    }

    public List<CategoryStudentCountDTO> getStudentsCountByMainCategories() {
        // Fetch all students
        List<Student> students = studentRepository.findAll();

        // Create a map to store student count per subcategory
        Map<String, Long> mainCategoryCounts = new HashMap<>();


        // Iterate over students and their categories
        for (Student student : students) {
            for (Category studentCategory : student.getCategories()) {
                // Check if the student category is a subcategory of the professor's main category
                if (studentCategory.getParentCategory() == null) {
                    // Count students for the corresponding subcategory
                    mainCategoryCounts.put(studentCategory.getName(),
                            mainCategoryCounts.getOrDefault(studentCategory.getName(), 0L) + 1);
                }
            }
        }

        // Convert the map to a list of DTOs
        List<CategoryStudentCountDTO> result = new ArrayList<>();
        for (Map.Entry<String, Long> entry : mainCategoryCounts.entrySet()) {
            result.add(new CategoryStudentCountDTO(entry.getKey(), entry.getValue()));
        }

        return result;
    }
}
