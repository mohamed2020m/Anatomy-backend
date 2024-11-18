package com.terraViva.services.interfaces;

import com.terraViva.dto.CategoryDTO;
import com.terraViva.dto.CategoryStudentCountDTO;
import com.terraViva.dto.ProfessorDTO;
import com.terraViva.exceptions.UserNotFoundException;

import java.util.List;


public interface ProfessorService {
    
    ProfessorDTO saveProfessor(ProfessorDTO professorDTO);

    ProfessorDTO getProfessorById(Long professorId) throws UserNotFoundException;

    List<ProfessorDTO> getAllProfessors();

    ProfessorDTO updateProfessor(ProfessorDTO professorDTO)throws UserNotFoundException;

    void deleteProfessor(Long professorId) throws UserNotFoundException;

    ProfessorDTO getProfessorInfo(String username);

    Long getProfessorsCount();

    List<Object[]> getProfessorsByCategory();

    List<CategoryDTO> getSubCategoriesOfProfessor(Long professorId);

    Long getSubCategoriesCountByProfessorId(Long professorId);

    List<CategoryStudentCountDTO> getCategoryStudentCounts(Long professorId);
}
