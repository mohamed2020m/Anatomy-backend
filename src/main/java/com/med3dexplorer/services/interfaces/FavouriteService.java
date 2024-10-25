package com.med3dexplorer.services.interfaces;

import com.med3dexplorer.dto.FavouriteDTO;
import com.med3dexplorer.exceptions.UserNotFoundException;

import java.util.List;

public interface FavouriteService {
    FavouriteDTO saveFavourite(FavouriteDTO favouriteDTO);

    FavouriteDTO getFavouriteById(Long favouriteId) throws UserNotFoundException;

    List<FavouriteDTO> getAllFavourites();

    FavouriteDTO updateFavourite(FavouriteDTO favouriteDTO)throws UserNotFoundException;

    void deleteFavourite(Long favouriteId) throws UserNotFoundException;
}
