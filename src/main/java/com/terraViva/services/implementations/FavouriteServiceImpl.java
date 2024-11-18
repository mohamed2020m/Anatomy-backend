package com.terraViva.services.implementations;

import com.terraViva.dto.FavouriteDTO;
import com.terraViva.exceptions.UserNotFoundException;
import com.terraViva.mapper.FavouriteDTOConverter;
import com.terraViva.models.Favourite;
import com.terraViva.repositories.FavouriteRepository;
import com.terraViva.services.interfaces.FavouriteService;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
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
        favourite.setCreatedAt(LocalDateTime.now());
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
        existingFavourite.setUpdatedAt(LocalDateTime.now());
        Favourite updatedFavourite = favouriteRepository.save(existingFavourite);
        return favouriteDTOConverter.toDto(updatedFavourite);
    }


    @Override
    public void deleteFavourite(Long favouriteId) throws UserNotFoundException {
        Favourite favourite=favouriteRepository.findById(favouriteId).orElseThrow(() -> new UserNotFoundException("Favourite not found"));
        favouriteRepository.delete(favourite);
    }

}