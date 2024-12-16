package com.terraViva.services.interfaces;

import com.terraViva.dto.FavouriteDTO;
import com.terraViva.dto.ThreeDObjectDTO;
import com.terraViva.exceptions.ThreeDObjectNotFoundException;
import com.terraViva.exceptions.UserNotFoundException;

import java.util.List;

public interface FavouriteService {
    FavouriteDTO saveFavourite(FavouriteDTO favouriteDTO);

    FavouriteDTO getFavouriteById(Long favouriteId) throws UserNotFoundException;

    List<FavouriteDTO> getAllFavourites();

    FavouriteDTO updateFavourite(FavouriteDTO favouriteDTO)throws UserNotFoundException;

    void deleteFavourite(Long favouriteId) throws UserNotFoundException;

    void addFavorite(Long objectId, Long studentId) throws ThreeDObjectNotFoundException;

    List<ThreeDObjectDTO> getFavoriteByStudent(Long studentId);
}
