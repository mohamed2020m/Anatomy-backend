package com.med3dexplorer.mapper;

import com.med3dexplorer.dto.UserDTO;
import com.med3dexplorer.models.User;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class UserDTOConverter {


    @Autowired
    private ModelMapper modelMapper;

    public User toEntity(UserDTO usersDTO) {
        User user = modelMapper.map(usersDTO, User.class);
        return user;
    }

    public UserDTO toDto(User users) {
        UserDTO usersDTO =modelMapper.map(users, UserDTO.class);
        return usersDTO;
    }

}
