package com.med3dexplorer.services.interfaces;

import com.med3dexplorer.dto.ProfessorDTO;
import com.med3dexplorer.exceptions.UserNotFoundException;

import java.util.List;


public interface ProfessorService {
    
    ProfessorDTO saveProfessor(ProfessorDTO professorDTO);

    ProfessorDTO getProfessorById(Long professorId) throws UserNotFoundException;

    List<ProfessorDTO> getAllProfessors();

    ProfessorDTO updateProfessor(ProfessorDTO professorDTO)throws UserNotFoundException;

    void deleteProfessor(Long professorId) throws UserNotFoundException;

    ProfessorDTO getProfessorInfo(String username);
}
