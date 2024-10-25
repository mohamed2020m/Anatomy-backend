package com.med3dexplorer.services.implementations;

import com.med3dexplorer.dto.FavouriteDTO;
import com.med3dexplorer.exceptions.UserNotFoundException;
import com.med3dexplorer.mapper.FavouriteDTOConverter;
import com.med3dexplorer.models.Favourite;
import com.med3dexplorer.repositories.FavouriteRepository;
import com.med3dexplorer.services.interfaces.FavouriteService;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class FavouriteServiceImpl implements FavouriteService {

    private final FavouriteDTOConverter favouriteDTOConverter;
    private FavouriteRepository favouriteRepository;


    public FavouriteServiceImpl(FavouriteRepository favouriteRepository, FavouriteDTOConverter favouriteDTOConverter) {
        this.favouriteDTOConverter = favouriteDTOConverter;
        this.favouriteRepository = favouriteRepository;
    }


    @Override
    public FavouriteDTO saveFavourite(FavouriteDTO favouriteDTO){
        Favourite favourite=favouriteDTOConverter.toEntity(favouriteDTO);
        FavouriteDTO savedFavourite =favouriteDTOConverter.toDto(favouriteRepository.save(favourite));
        return savedFavourite;
    }

    @Override
    public FavouriteDTO getFavouriteById(Long favouriteId) throws UserNotFoundException {
        Favourite favourite = favouriteRepository.findById(favouriteId).orElseThrow(() -> new UserNotFoundException("Favourite not found"));
        FavouriteDTO favouriteDTO = favouriteDTOConverter.toDto(favourite);
        return favouriteDTO;
    }

    @Override
    public List<FavouriteDTO> getAllFavourites() {
        List<Favourite> favourites = favouriteRepository.findAll();
        List<FavouriteDTO> favouriteDTOs = favourites.stream().map(favourite -> favouriteDTOConverter.toDto(favourite)).collect(Collectors.toList());
        return favouriteDTOs;
    }

    @Override
    public FavouriteDTO updateFavourite(FavouriteDTO favouriteDTO) throws UserNotFoundException {
        Favourite existingFavourite = favouriteRepository.findById(favouriteDTO.getId())
                .orElseThrow(() -> new UserNotFoundException("Favourite not found with id: " + favouriteDTO.getId()));
        Favourite updatedFavourite = favouriteRepository.save(favouriteDTOConverter.toEntity(favouriteDTO));
        return favouriteDTOConverter.toDto(updatedFavourite);
    }


    @Override
    public void deleteFavourite(Long favouriteId) throws UserNotFoundException {
        Favourite favourite=favouriteRepository.findById(favouriteId).orElseThrow(() -> new UserNotFoundException("Favourite not found"));
        favouriteRepository.delete(favourite);
    }

}