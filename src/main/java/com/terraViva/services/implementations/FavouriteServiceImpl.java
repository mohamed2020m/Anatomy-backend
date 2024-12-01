package com.terraViva.services.implementations;

import com.terraViva.dto.FavouriteDTO;
import com.terraViva.dto.ThreeDObjectDTO;
import com.terraViva.exceptions.ThreeDObjectNotFoundException;
import com.terraViva.exceptions.UserNotFoundException;
import com.terraViva.mapper.FavouriteDTOConverter;
import com.terraViva.mapper.ThreeDObjectDTOConverter;
import com.terraViva.models.Favourite;
import com.terraViva.models.Student;
import com.terraViva.models.ThreeDObject;
import com.terraViva.repositories.FavouriteRepository;
import com.terraViva.repositories.StudentRepository;
import com.terraViva.repositories.ThreeDObjectRepository;
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
    private final ThreeDObjectDTOConverter threeDObjectDTOConverter;
    private FavouriteRepository favouriteRepository;
    private final ThreeDObjectRepository threeDObjectRepository;
    private final StudentRepository studentRepository;


    public FavouriteServiceImpl(
            FavouriteRepository favouriteRepository,
            FavouriteDTOConverter favouriteDTOConverter,
            ThreeDObjectRepository threeDObjectRepository,
            StudentRepository studentRepository,
            ThreeDObjectDTOConverter threeDObjectDTOConverter
    ) {
        this.favouriteDTOConverter = favouriteDTOConverter;
        this.favouriteRepository = favouriteRepository;
        this.threeDObjectRepository = threeDObjectRepository;
        this.studentRepository = studentRepository;
        this.threeDObjectDTOConverter = threeDObjectDTOConverter;
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

    @Override
    public void addFavorite(Long objectId, Long studentId) throws ThreeDObjectNotFoundException {
        ThreeDObject threeDObject = threeDObjectRepository.findById(objectId)
                .orElseThrow(() -> new ThreeDObjectNotFoundException("3D Object with ID " + objectId + " not found."));
        Student student = studentRepository.findById(studentId)
                .orElseThrow(() -> new UserNotFoundException("Student with ID " + studentId + " not found."));

        // Check if the favorite already exists to prevent duplication
        boolean exists = favouriteRepository.existsByThreeDObjectAndStudent(threeDObject, student);
        if (exists) {
            throw new IllegalStateException("This object is already marked as a favorite.");
        }

        Favourite favourite = new Favourite();
        favourite.setThreeDObject(threeDObject);
        favourite.setStudent(student);
        favouriteRepository.save(favourite);
    }

    public void removeFavorite(Long objectId, Long studentId) throws ThreeDObjectNotFoundException {
        ThreeDObject threeDObject = threeDObjectRepository.findById(objectId)
                .orElseThrow(() -> new ThreeDObjectNotFoundException("3D Object with ID " + objectId + " not found."));
        Student student = studentRepository.findById(studentId)
                .orElseThrow(() -> new UserNotFoundException("Student with ID " + studentId + " not found."));

        // Find the existing favorite relationship
        Favourite favourite = favouriteRepository.findByThreeDObjectAndStudent(threeDObject, student)
                .orElseThrow(() -> new IllegalStateException("This object is not marked as a favorite by the student."));

        // Remove the favourite from the student's list
        student.getFavourites().remove(favourite);

        // Remove the Favourite entry from the database
        favouriteRepository.delete(favourite);
    }


    @Override
    public List<ThreeDObjectDTO> getFavoriteByStudent(Long studentId) {
        // Validate that the student exists
        if (!studentRepository.existsById(studentId)) {
            throw new UserNotFoundException("Student with ID " + studentId + " not found.");
        }

        // Retrieve all Favourite entities for the student
        // List<Favourite> favourites = favouriteRepository.findByStudentId(studentId);

        List<ThreeDObject> threeDObjects = favouriteRepository.findThreeDObjectsMarkedAsFavoriteByStudent(studentId);

        // Extract the associated ThreeDObjects
//        List<ThreeDObject> threeDObjects = favourites.stream()
//                .map(Favourite::getThreeDObject)
//                .collect(Collectors.toList());


        // Return the DTOs
        return threeDObjects.stream()
                .map(threeDObjectDTOConverter::toDto)
                .collect(Collectors.toList());
    }


}