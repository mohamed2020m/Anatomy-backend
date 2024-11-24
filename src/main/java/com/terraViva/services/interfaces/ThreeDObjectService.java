package com.terraViva.services.interfaces;

import com.terraViva.dto.ThreeDObjectDTO;
import com.terraViva.exceptions.ThreeDObjectNotFoundException;
import com.terraViva.models.ThreeDObject;

import java.util.List;

public interface ThreeDObjectService {
    ThreeDObjectDTO saveThreeDObject(ThreeDObjectDTO threeDObjectDTO);

    ThreeDObjectDTO getThreeDObjectById(Long threeDObjectId) throws ThreeDObjectNotFoundException;

    List<ThreeDObjectDTO> getThreeDObjectByProfessorId(Long profId) throws ThreeDObjectNotFoundException;

    List<ThreeDObjectDTO> getAllThreeDObjects();

    ThreeDObjectDTO updateThreeDObject(ThreeDObjectDTO threeDObjectDTO)throws ThreeDObjectNotFoundException;

    void deleteThreeDObject(Long threeDObjectId) throws ThreeDObjectNotFoundException;

    List<ThreeDObject> getThreeDObjectByCategory(Long categoryId);
}
