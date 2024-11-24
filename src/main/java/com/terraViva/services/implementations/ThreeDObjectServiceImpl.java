package com.terraViva.services.implementations;


import com.terraViva.dto.ThreeDObjectDTO;
import com.terraViva.exceptions.ThreeDObjectNotFoundException;
import com.terraViva.mapper.ThreeDObjectDTOConverter;
import com.terraViva.models.Professor;
import com.terraViva.models.ThreeDObject;
import com.terraViva.repositories.ProfessorRepository;
import com.terraViva.repositories.ThreeDObjectRepository;
import com.terraViva.services.interfaces.ThreeDObjectService;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;


@Service
@Transactional

public class ThreeDObjectServiceImpl implements ThreeDObjectService {


    private final ThreeDObjectDTOConverter threeDObjectDTOConverter;
    private ThreeDObjectRepository threeDObjectRepository;
    private ProfessorRepository professorRepository;


    public ThreeDObjectServiceImpl(ProfessorRepository professorRepository,ThreeDObjectRepository threeDObjectRepository, ThreeDObjectDTOConverter threeDObjectDTOConverter) {
        this.threeDObjectDTOConverter = threeDObjectDTOConverter;
        this.threeDObjectRepository = threeDObjectRepository;
        this.professorRepository = professorRepository;
    }


    @Override
    public ThreeDObjectDTO saveThreeDObject(ThreeDObjectDTO threeDObjectDTO) {
        ThreeDObject threeDObject = threeDObjectDTOConverter.toEntity(threeDObjectDTO);
        threeDObject.setCreatedAt(LocalDateTime.now());
        ThreeDObject savedObject = threeDObjectRepository.save(threeDObject);
        ThreeDObjectDTO resultDTO = threeDObjectDTOConverter.toDto(savedObject);
        return resultDTO;
    }


    @Override
    public ThreeDObjectDTO getThreeDObjectById(Long threeDObjectId) throws ThreeDObjectNotFoundException {
        ThreeDObject threeDObject = threeDObjectRepository.findById(threeDObjectId).orElseThrow(() -> new ThreeDObjectNotFoundException("ThreeDObject not found"));
        ThreeDObjectDTO threeDObjectDTO = threeDObjectDTOConverter.toDto(threeDObject);
        return threeDObjectDTO;
    }

    @Override
    public List<ThreeDObjectDTO> getThreeDObjectByProfessorId(Long profId) throws ThreeDObjectNotFoundException {
        Professor professor = professorRepository.findById(profId)
                .orElseThrow(() -> new ThreeDObjectNotFoundException("Professor not found with id: " + profId));

        List<ThreeDObject> threeDObjects = threeDObjectRepository.findByProfessor(professor);
        return threeDObjects.stream()
                .map(threeDObjectDTOConverter::toDto)
                .collect(Collectors.toList());
    }


    @Override
    public List<ThreeDObjectDTO> getAllThreeDObjects() {
        List<ThreeDObject> threeDObjects = threeDObjectRepository.findAll();
        List<ThreeDObjectDTO> threeDObjectDTOs = threeDObjects.stream().map(threeDObject -> threeDObjectDTOConverter.toDto(threeDObject)).collect(Collectors.toList());
        return threeDObjectDTOs;
    }

    @Override
    public ThreeDObjectDTO updateThreeDObject(ThreeDObjectDTO threeDObjectDTO) throws ThreeDObjectNotFoundException {
        ThreeDObject existingThreeDObject = threeDObjectRepository.findById(threeDObjectDTO.getId())
                .orElseThrow(() -> new ThreeDObjectNotFoundException("ThreeDObject not found with id: " + threeDObjectDTO.getId()));

        if (threeDObjectDTO.getName() != null) {
            existingThreeDObject.setName(threeDObjectDTO.getName());
        }
        if (threeDObjectDTO.getDescription() != null) {
            existingThreeDObject.setDescription(threeDObjectDTO.getDescription());
        }

        if (threeDObjectDTO.getDescriptionAudio() != null) {
            existingThreeDObject.setDescriptionAudio(threeDObjectDTO.getDescriptionAudio());
        }
        if (threeDObjectDTO.getImage() != null) {
            existingThreeDObject.setImage(threeDObjectDTO.getImage());
        }
        if (threeDObjectDTO.getProfessor() != null) {
            existingThreeDObject.setProfessor(threeDObjectDTO.getProfessor());
        }
        existingThreeDObject.setUpdatedAt(LocalDateTime.now());
        ThreeDObject updatedThreeDObject = threeDObjectRepository.save(existingThreeDObject);
        return threeDObjectDTOConverter.toDto(updatedThreeDObject);
    }

    @Override
    public void deleteThreeDObject(Long threeDObjectId) throws ThreeDObjectNotFoundException {
        ThreeDObject threeDObject=threeDObjectRepository.findById(threeDObjectId).orElseThrow(() -> new ThreeDObjectNotFoundException("ThreeDObject not found"));
        threeDObjectRepository.delete(threeDObject);
    }

    public Long getThreeDObjectCountByProfessor(Long professorId) {
        return threeDObjectRepository.threeDObjectCountByProfessorId(professorId);
    }

    public List<Object[]> getThreeDObjectByProfessorSubCategories(Long professorId) {
        return threeDObjectRepository.findThreeDObjectCountsByProfessorSubCategories(professorId);
    }

    @Override
    public List<ThreeDObject> getThreeDObjectByCategory(Long categoryId) {
        return threeDObjectRepository.getThreeDObjectBySubCategory(categoryId);
    }

    public List<ThreeDObjectDTO> getLastFiveThreeDObjects() {
        List<ThreeDObject> lastFiveThreeDObjects = threeDObjectRepository.findTop5ByOrderByCreatedAtDesc();
        return lastFiveThreeDObjects.stream()
                .map(threeDObject -> threeDObjectDTOConverter.toDto(threeDObject))
                .collect(Collectors.toList());
    }
}