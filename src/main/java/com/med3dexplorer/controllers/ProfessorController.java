package com.med3dexplorer.controllers;

import com.med3dexplorer.dto.CategoryAssignmentRequest;
import com.med3dexplorer.dto.CategoryDTO;
import com.med3dexplorer.dto.ProfessorDTO;
import com.med3dexplorer.services.implementations.ProfessorServiceImpl;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/professors")
@CrossOrigin("*")
public class ProfessorController {

   

        private ProfessorServiceImpl professorService;

        public  ProfessorController( ProfessorServiceImpl  professorService) {
            this. professorService =  professorService;
        }


        @PostMapping
        public ResponseEntity<ProfessorDTO> saveProfessor(@RequestBody ProfessorDTO professorDTO) {
            return ResponseEntity.ok(professorService.saveProfessor(professorDTO));
        }

        @GetMapping("/{id}")
        public ResponseEntity<ProfessorDTO> getProfessorById(@PathVariable Long id){
            return ResponseEntity.ok(professorService.getProfessorById(id));
        }


        @GetMapping
        public ResponseEntity<List<ProfessorDTO>> getAllProfessors() {
            return ResponseEntity.ok(professorService.getAllProfessors());
        }


        @PutMapping("/{id}")
        public ResponseEntity<ProfessorDTO> updateProfessor(@PathVariable Long id, @RequestBody ProfessorDTO professorDTO) {
            professorDTO.setId(id);
            ProfessorDTO updatedProfessor = professorService.updateProfessor(professorDTO);
            return ResponseEntity.ok(updatedProfessor);
        }


        @DeleteMapping("/{id}")
        public ResponseEntity<String> deleteProfessor(@PathVariable Long id){
            professorService.deleteProfessor(id);
            return new ResponseEntity("Professor deleted successfully", HttpStatus.OK);
        }

        @GetMapping("/count")
        public Long getProfessorCount() {
            return professorService.getProfessorsCount();
        }

        @GetMapping("/by-categories")
        public List<Object[]> getProfessorsByCategory() {
            return professorService.getProfessorsByCategory();
        }

        @GetMapping("/{id}/sub-categories")
        public List<CategoryDTO> getSubCategoriesOfProfessor(@PathVariable Long id) {
            return professorService.getSubCategoriesOfProfessor(id);
        }

        @PostMapping("/assign-category")
        public ResponseEntity<String> assignCategoryToStudents(@RequestBody CategoryAssignmentRequest request) {
            professorService.assignCategoryToStudents(request.getCategoryId(), request.getStudentIds());
            return ResponseEntity.ok("Category assigned successfully to students.");
        }

}
