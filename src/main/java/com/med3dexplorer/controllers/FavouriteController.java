package com.med3dexplorer.controllers;


import com.med3dexplorer.dto.FavouriteDTO;
import com.med3dexplorer.services.implementations.FavouriteServiceImpl;
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
}