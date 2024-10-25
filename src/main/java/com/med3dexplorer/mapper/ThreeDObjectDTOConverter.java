package com.med3dexplorer.mapper;

import com.med3dexplorer.dto.ThreeDObjectDTO;
import com.med3dexplorer.models.ThreeDObject;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class ThreeDObjectDTOConverter {


    @Autowired
    private ModelMapper modelMapper;

    public ThreeDObject toEntity(ThreeDObjectDTO threeDObjectDTO) {
        ThreeDObject threeDObject = modelMapper.map(threeDObjectDTO, ThreeDObject.class);
        return threeDObject;
    }

    public  ThreeDObjectDTO toDto(ThreeDObject threeDObject) {
        ThreeDObjectDTO threeDObjectDTO =modelMapper.map(threeDObject,ThreeDObjectDTO.class);
        return threeDObjectDTO;
    }

}