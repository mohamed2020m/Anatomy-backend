package com.med3dexplorer.controllers;


import com.med3dexplorer.dto.AdministratorDTO;
import com.med3dexplorer.services.implementations.AdministratorServiceImpl;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/administrators")
@CrossOrigin("*")
public class AdministratorController {

    private AdministratorServiceImpl administratorService;

    public  AdministratorController( AdministratorServiceImpl  administratorService) {
        this. administratorService =  administratorService;
    }

    @PostMapping
    public ResponseEntity<AdministratorDTO> saveAdministrator(@RequestBody AdministratorDTO administratorDTO) {
        return ResponseEntity.ok(administratorService.saveAdministrator(administratorDTO));
    }

    @GetMapping("/{id}")
    public ResponseEntity<AdministratorDTO> getAdministratorById(@PathVariable Long id){
        return ResponseEntity.ok(administratorService.getAdministratorById(id));
    }


    @GetMapping
    public ResponseEntity<List<AdministratorDTO>> getAllAdministrators() {
        return ResponseEntity.ok(administratorService.getAllAdministrators());
    }


    @PutMapping("/{id}")
    public ResponseEntity<AdministratorDTO> updateAdministrator(@PathVariable Long id, @RequestBody AdministratorDTO administratorDTO) {
        administratorDTO.setId(id);
        AdministratorDTO updatedAdministrator = administratorService.updateAdministrator(administratorDTO);
        return ResponseEntity.ok(updatedAdministrator);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<String> deleteAdministrator(@PathVariable Long id){
        administratorService.deleteAdministrator(id);
        return new ResponseEntity("Administrator deleted successfully", HttpStatus.OK);
    }

    @GetMapping("/count")
    public Long getCategoriesCount() {
        return administratorService.getAdminsCount();
    }
}