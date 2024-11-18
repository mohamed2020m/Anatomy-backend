package com.terraViva.services.implementations;

import com.terraViva.dto.CategoryDTO;
import com.terraViva.dto.CategoryStudentCountDTO;
import com.terraViva.dto.ProfessorDTO;
import com.terraViva.exceptions.CategoryNotFoundException;
import com.terraViva.exceptions.UserNotFoundException;
import com.terraViva.mapper.ProfessorDTOConverter;
import com.terraViva.models.Category;
import com.terraViva.models.Professor;
import com.terraViva.models.Student;
import com.terraViva.repositories.CategoryRepository;
import com.terraViva.repositories.ProfessorRepository;
import com.terraViva.repositories.StudentRepository;
import com.terraViva.services.interfaces.ProfessorService;
import jakarta.transaction.Transactional;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@Transactional
public class ProfessorServiceImpl implements ProfessorService {
    private final ProfessorDTOConverter  professorDTOConverter;
    private ProfessorRepository professorRepository;
    private CategoryServiceImpl categoryService;
    private CategoryRepository categoryRepository;
    private StudentRepository studentRepository;
    private PasswordEncoder passwordEncoder;

    public ProfessorServiceImpl(PasswordEncoder passwordEncoder,ProfessorRepository professorRepository, ProfessorDTOConverter professorDTOConverter, CategoryServiceImpl categoryService, CategoryRepository categoryRepository, StudentRepository studentRepository) {
        this.professorDTOConverter = professorDTOConverter;
        this.professorRepository = professorRepository;
        this.categoryService = categoryService;
        this.categoryRepository = categoryRepository;
        this.studentRepository = studentRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public ProfessorDTO saveProfessor(ProfessorDTO professorDTO){
        Professor professor=professorDTOConverter.toEntity(professorDTO);
        professor.setCreatedAt(LocalDateTime.now());
        ProfessorDTO savedProfessor =professorDTOConverter.toDto(professorRepository.save(professor));
        return savedProfessor;
    }

    @Override
    public ProfessorDTO getProfessorById(Long professorId) throws UserNotFoundException {
        Professor professor = professorRepository.findById(professorId).orElseThrow(() -> new UserNotFoundException("Professor not found"));
        ProfessorDTO professorDTO = professorDTOConverter.toDto(professor);
        return professorDTO;
    }

    @Override
    public List<ProfessorDTO> getAllProfessors() {
        List<Professor> professors = professorRepository.findAll();
        List<ProfessorDTO> professorDTOs = professors.stream().map(professor -> professorDTOConverter.toDto(professor)).collect(Collectors.toList());
        return professorDTOs;
    }

    @Override
    public ProfessorDTO updateProfessor(ProfessorDTO professorDTO) throws UserNotFoundException {
        Professor existingProfessor = professorRepository.findById(professorDTO.getId())
                .orElseThrow(() -> new UserNotFoundException("Professor not found with id: " + professorDTO.getId()));
        if (professorDTO.getEmail() != null) {
            existingProfessor.setEmail(professorDTO.getEmail());
        }
        if (professorDTO.getFirstName() != null) {
            existingProfessor.setFirstName(professorDTO.getFirstName());
        }
        if (professorDTO.getLastName() != null) {
            existingProfessor.setLastName(professorDTO.getLastName());
        }
        if (professorDTO.getPassword() != null) {
            existingProfessor.setPassword(passwordEncoder.encode(professorDTO.getPassword()));
        }
        if (professorDTO.getCreatedAt() != null) {
            existingProfessor.setCreatedAt(professorDTO.getCreatedAt());
        }

        existingProfessor.setUpdatedAt(LocalDateTime.now());
        Professor updatedProfessor = professorRepository.save(existingProfessor);
        return professorDTOConverter.toDto(updatedProfessor);
    }

    @Override
    public void deleteProfessor(Long professorId) throws UserNotFoundException {
        Professor professor=professorRepository.findById(professorId).orElseThrow(() -> new UserNotFoundException("Professor not found"));
        professorRepository.delete(professor);
    }

    @Override
    public ProfessorDTO getProfessorInfo(String username)  throws UserNotFoundException{
        Professor prof = professorRepository.findByEmail(username)
                .orElseThrow(() -> new UserNotFoundException("Professor not found"));
        return professorDTOConverter.toDto(prof);
    }

    @Override
    public Long getProfessorsCount() {
        return professorRepository.count();
    }

    @Override
    public List<Object[]> getProfessorsByCategory(){
        return professorRepository.countProfessorsByCategory();
    }

    @Override
    public List<CategoryDTO> getSubCategoriesOfProfessor(Long professorId) {
        Professor professor = professorRepository.findById(professorId).orElseThrow(() -> new UserNotFoundException("Professor not found"));

        // Check if the professor has an associated category
        Category category = professor.getCategory();
        if (category == null) {
            throw new CategoryNotFoundException("Professor has no associated category");
        }

        Long mainCategoryId = category.getId();

        return categoryService.getSubCategoryByCategoryId(mainCategoryId);
    }

    public void assignCategoryToStudents(Long categoryId, List<Long> studentIds) {

        Category category = categoryRepository.findById(categoryId)
                .orElseThrow(() -> new UserNotFoundException("Category not found with id " + categoryId));


        List<Student> students = studentRepository.findAllById(studentIds);

        if (students.isEmpty()) {
            throw new UserNotFoundException("No students found with provided IDs");
        }

        for (Student student : students) {
            boolean exists = student.getCategories().stream()
                    .anyMatch(c -> c.getId().equals(category.getId()));

            if (!exists) {
                student.getCategories().add(category);
                student.setUpdatedAt(LocalDateTime.now());
            }

            if(student.getCategories().stream().noneMatch(c -> c.getId().equals(category.getParentCategory().getId()))){
                student.getCategories().add(category.getParentCategory());
            }

        }



        studentRepository.saveAll(students);
    }

    @Override
    public Long getSubCategoriesCountByProfessorId(Long professorId) {
        return professorRepository.countSubCategoriesByProfessorId(professorId);
    }

    @Override
    public List<CategoryStudentCountDTO> getCategoryStudentCounts(Long professorId) {
        // Get the professor by ID
        Professor professor = professorRepository.findById(professorId)
                .orElseThrow(() -> new RuntimeException("Professor not found"));

        // Get the professor's main category
        Category professorMainCategory = professor.getCategory();

        // Fetch all students (you can add filtering logic if needed)
        List<Student> students = studentRepository.findAll();

        // Create a map to store student count per subcategory
        Map<String, Long> subcategoryCounts = new HashMap<>();

        // Iterate over students and their categories
        for (Student student : students) {
            for (Category studentCategory : student.getCategories()) {
                // Check if the student category is a subcategory of the professor's main category
                if (studentCategory.getParentCategory() != null &&
                        studentCategory.getParentCategory().equals(professorMainCategory)) {
                    // Count students for the corresponding subcategory
                    subcategoryCounts.put(studentCategory.getName(),
                            subcategoryCounts.getOrDefault(studentCategory.getName(), 0L) + 1);
                }
            }
        }

        // Convert the map to a list of DTOs
        List<CategoryStudentCountDTO> result = new ArrayList<>();
        for (Map.Entry<String, Long> entry : subcategoryCounts.entrySet()) {
            result.add(new CategoryStudentCountDTO(entry.getKey(), entry.getValue()));
        }

        return result;
    }
}
