package com.terraViva.mapper;

import com.terraViva.dto.FavouriteDTO;
import com.terraViva.models.Favourite;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class FavouriteDTOConverter {


    @Autowired
    private ModelMapper modelMapper;

    public Favourite toEntity(FavouriteDTO favouriteDTO) {
        Favourite favourite = modelMapper.map(favouriteDTO, Favourite.class);
        return favourite;
    }

    public  FavouriteDTO toDto(Favourite favourite) {
        FavouriteDTO favouriteDTO =modelMapper.map(favourite,FavouriteDTO.class);
        return favouriteDTO;
    }

}
