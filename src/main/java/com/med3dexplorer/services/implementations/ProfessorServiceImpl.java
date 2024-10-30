package com.med3dexplorer.services.implementations;

import com.med3dexplorer.dto.CategoryDTO;
import com.med3dexplorer.dto.ProfessorDTO;
import com.med3dexplorer.exceptions.CategoryNotFoundException;
import com.med3dexplorer.exceptions.UserNotFoundException;
import com.med3dexplorer.mapper.ProfessorDTOConverter;
import com.med3dexplorer.models.Category;
import com.med3dexplorer.models.Professor;
import com.med3dexplorer.repositories.ProfessorRepository;
import com.med3dexplorer.services.interfaces.ProfessorService;
import jakarta.transaction.Transactional;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class ProfessorServiceImpl implements ProfessorService {
    private final ProfessorDTOConverter  professorDTOConverter;
    private ProfessorRepository professorRepository;
    private CategoryServiceImpl categoryService;
    private PasswordEncoder passwordEncoder;

    public ProfessorServiceImpl(PasswordEncoder passwordEncoder,ProfessorRepository professorRepository, ProfessorDTOConverter professorDTOConverter, CategoryServiceImpl categoryService) {
        this.professorDTOConverter = professorDTOConverter;
        this.professorRepository = professorRepository;
        this.categoryService = categoryService;
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

}
