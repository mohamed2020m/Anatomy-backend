package com.med3dexplorer.mapper;

import com.med3dexplorer.dto. ProfessorDTO;
import com.med3dexplorer.models. Professor;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class  ProfessorDTOConverter {


    @Autowired
    private ModelMapper modelMapper;

    public  Professor toEntity( ProfessorDTO  professorsDTO) {
         Professor  professor = modelMapper.map( professorsDTO,  Professor.class);
        return  professor;
    }

    public  ProfessorDTO toDto( Professor  professors) {
         ProfessorDTO  professorsDTO =modelMapper.map( professors,  ProfessorDTO.class);
        return  professorsDTO;
    }

}
