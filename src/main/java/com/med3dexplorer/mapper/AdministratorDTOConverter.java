package com.med3dexplorer.mapper;

import com.med3dexplorer.dto.AdministratorDTO;
import com.med3dexplorer.models.Administrator;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class  AdministratorDTOConverter {


    @Autowired
    private ModelMapper modelMapper;

    public Administrator toEntity(AdministratorDTO administratorsDTO) {
        Administrator  administrator = modelMapper.map( administratorsDTO,  Administrator.class);
        return  administrator;
    }

    public  AdministratorDTO toDto( Administrator  administrators) {
        AdministratorDTO  administratorsDTO =modelMapper.map( administrators,  AdministratorDTO.class);
        return  administratorsDTO;
    }

}
