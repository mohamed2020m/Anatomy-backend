package com.med3dexplorer.services.implementations;

import com.med3dexplorer.dto.ProfessorDTO;
import com.med3dexplorer.exceptions.UserNotFoundException;
import com.med3dexplorer.mapper.ProfessorDTOConverter;
import com.med3dexplorer.models.Professor;
import com.med3dexplorer.repositories.ProfessorRepository;
import com.med3dexplorer.services.interfaces.ProfessorService;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class ProfessorServiceImpl implements ProfessorService {
    private final ProfessorDTOConverter  professorDTOConverter;
    private ProfessorRepository professorRepository;

    public ProfessorServiceImpl(ProfessorRepository professorRepository, ProfessorDTOConverter professorDTOConverter) {
        this.professorDTOConverter = professorDTOConverter;
        this.professorRepository = professorRepository;
    }

    @Override
    public ProfessorDTO saveProfessor(ProfessorDTO professorDTO){
        Professor professor=professorDTOConverter.toEntity(professorDTO);
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
        Professor updatedProfessor = professorRepository.save(professorDTOConverter.toEntity(professorDTO));
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
}
