package com.terraViva.controllers;


import com.terraViva.dto.FavouriteDTO;
import com.terraViva.dto.ThreeDObjectDTO;
import com.terraViva.exceptions.ThreeDObjectNotFoundException;
import com.terraViva.exceptions.UserNotFoundException;
import com.terraViva.services.implementations.FavouriteServiceImpl;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/favourites")
@CrossOrigin("*")
public class FavouriteController {



    private FavouriteServiceImpl favouriteService;

    public  FavouriteController( FavouriteServiceImpl  favouriteService) {
        this. favouriteService =  favouriteService;
    }


    @PostMapping
    public ResponseEntity<FavouriteDTO> saveFavourite(@RequestBody FavouriteDTO favouriteDTO) {
        return ResponseEntity.ok(favouriteService.saveFavourite(favouriteDTO));
    }

    @GetMapping("/{id}")
    public ResponseEntity<FavouriteDTO> getFavouriteById(@PathVariable Long id){
        return ResponseEntity.ok(favouriteService.getFavouriteById(id));
    }


    @GetMapping
    public ResponseEntity<List<FavouriteDTO>> getAllFavourites() {
        return ResponseEntity.ok(favouriteService.getAllFavourites());
    }


    @PutMapping("/{id}")
    public ResponseEntity<FavouriteDTO> updateFavourite(@PathVariable Long id, @RequestBody FavouriteDTO favouriteDTO) {
        favouriteDTO.setId(id);
        FavouriteDTO updatedFavourite = favouriteService.updateFavourite(favouriteDTO);
        return ResponseEntity.ok(updatedFavourite);
    }


    @DeleteMapping("/{id}")
    public ResponseEntity<String> deleteFavourite(@PathVariable Long id){
        favouriteService.deleteFavourite(id);
        return new ResponseEntity("Favourite deleted successfully", HttpStatus.OK);
    }

    @PostMapping("/{objectId}/student/{studentId}")
    public ResponseEntity<String> addFavorite(@PathVariable Long objectId, @PathVariable Long studentId) {
        try {
            favouriteService.addFavorite(objectId, studentId);
            return ResponseEntity.ok("Object successfully marked as favorite.");
        } catch (ThreeDObjectNotFoundException | UserNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        } catch (IllegalStateException e) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(e.getMessage());
        }
    }

    @DeleteMapping("/{objectId}/student/{studentId}")
    public ResponseEntity<String> removeFavorite(@PathVariable Long objectId, @PathVariable Long studentId) {
        try {
            favouriteService.removeFavorite(objectId, studentId);
            return ResponseEntity.ok("Object successfully unmarked as favorite.");
        } catch (ThreeDObjectNotFoundException | UserNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        } catch (IllegalStateException e) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(e.getMessage());
        }
    }


    @GetMapping("/{studentId}/my-favourites")
    public ResponseEntity<List<ThreeDObjectDTO>> getFavoriteObjectsByStudent(@PathVariable Long studentId) {
        List<ThreeDObjectDTO> favoriteObjects = favouriteService.getFavoriteByStudent(studentId);

        return ResponseEntity.ok(favoriteObjects);
    }
}