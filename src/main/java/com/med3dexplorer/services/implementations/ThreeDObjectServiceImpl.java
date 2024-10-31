package com.med3dexplorer.services.implementations;


import com.med3dexplorer.dto.ThreeDObjectDTO;
import com.med3dexplorer.exceptions.ThreeDObjectNotFoundException;
import com.med3dexplorer.mapper.ThreeDObjectDTOConverter;
import com.med3dexplorer.models.ThreeDObject;
import com.med3dexplorer.repositories.ThreeDObjectRepository;
import com.med3dexplorer.services.interfaces.ThreeDObjectService;
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


    public ThreeDObjectServiceImpl(ThreeDObjectRepository threeDObjectRepository, ThreeDObjectDTOConverter threeDObjectDTOConverter) {
        this.threeDObjectDTOConverter = threeDObjectDTOConverter;
        this.threeDObjectRepository = threeDObjectRepository;
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

}