package com.terraViva.controllers;

import com.terraViva.dto.CategoryAssignmentRequest;
import com.terraViva.dto.CategoryDTO;
import com.terraViva.dto.CategoryStudentCountDTO;
import com.terraViva.dto.ProfessorDTO;
import com.terraViva.services.implementations.ProfessorServiceImpl;
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

    @GetMapping("/{id}/sub-categories/count")
    public Long getSubCategoriesCountByProfessor(@PathVariable Long id) {
        return professorService.getSubCategoriesCountByProfessorId(id);
    }

    @PostMapping("/assign-category")
    public ResponseEntity<String> assignCategoryToStudents(@RequestBody CategoryAssignmentRequest request) {
        professorService.assignCategoryToStudents(request.getCategoryId(), request.getStudentIds());
        return ResponseEntity.ok("Category assigned successfully to students.");
    }

    @GetMapping("/{professorId}/sub-categories/student-counts")
    public ResponseEntity<List<CategoryStudentCountDTO>> getSuCategoriesByStudents(@PathVariable Long professorId) {
        List<CategoryStudentCountDTO> categoryStudentCounts = professorService.getCategoryStudentCounts(professorId);
        return ResponseEntity.ok(categoryStudentCounts);
    }

}
