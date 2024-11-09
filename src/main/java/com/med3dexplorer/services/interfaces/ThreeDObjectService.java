package com.med3dexplorer.services.interfaces;

import com.med3dexplorer.dto.ThreeDObjectDTO;
import com.med3dexplorer.dto.ThreeDObjectDTO;
import com.med3dexplorer.exceptions.ThreeDObjectNotFoundException;

import java.util.List;

public interface ThreeDObjectService {
    ThreeDObjectDTO saveThreeDObject(ThreeDObjectDTO threeDObjectDTO);

    ThreeDObjectDTO getThreeDObjectById(Long threeDObjectId) throws ThreeDObjectNotFoundException;

    List<ThreeDObjectDTO> getThreeDObjectByProfessorId(Long profId) throws ThreeDObjectNotFoundException;

    List<ThreeDObjectDTO> getAllThreeDObjects();

    ThreeDObjectDTO updateThreeDObject(ThreeDObjectDTO threeDObjectDTO)throws ThreeDObjectNotFoundException;

    void deleteThreeDObject(Long threeDObjectId) throws ThreeDObjectNotFoundException;
    
}
