package com.terraViva.controllers;


import com.terraViva.dto.CategoryDTO;
import com.terraViva.services.implementations.CategoryServiceImpl;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/categories")
@CrossOrigin("*")
public class CategoryController {

    private CategoryServiceImpl categoryService;

    public  CategoryController( CategoryServiceImpl categoryService) {
        this. categoryService =  categoryService;
    }


    @PostMapping
    public ResponseEntity<CategoryDTO> saveCategory(@RequestBody CategoryDTO categoryDTO) {
        return ResponseEntity.ok(categoryService.saveCategory(categoryDTO));
    }

    @GetMapping("/{id}")
    public ResponseEntity<CategoryDTO> getCategoryById(@PathVariable Long id){
        return ResponseEntity.ok(categoryService.getCategoryById(id));
    }

    @GetMapping("/{id}/sub_categories")
    public ResponseEntity<List<CategoryDTO>> getSubCategoryByCategoryId(@PathVariable Long id){
        return ResponseEntity.ok(categoryService.getSubCategoryByCategoryId(id));
    }

    @GetMapping()
    public ResponseEntity<List<CategoryDTO>> getAllCategories() {
        return ResponseEntity.ok(categoryService.getAllCategories());
    }

    @PutMapping("/{id}")
    public ResponseEntity<CategoryDTO> updateCategory(@PathVariable Long id, @RequestBody CategoryDTO categoryDTO) {
        categoryDTO.setId(id);
        CategoryDTO updatedCategory = categoryService.updateCategory(categoryDTO);
        return ResponseEntity.ok(updatedCategory);
    }


    @DeleteMapping("/{id}")
    public ResponseEntity<String> deleteCategory(@PathVariable Long id){
        categoryService.deleteCategory(id);
        return new ResponseEntity("Category deleted successfully", HttpStatus.OK);
    }

    @GetMapping("/count")
    public Long getCategoriesCount() {
        return categoryService.getCategoriesCount();
    }


    @GetMapping("/main")
    public ResponseEntity<List<CategoryDTO>> getMainCategories() {
        return ResponseEntity.ok(categoryService.getMainCategories());
    }

    @GetMapping("/main/count")
    public ResponseEntity<Long> getMainCategoryCount() {
        return ResponseEntity.ok(categoryService.getMainCategoriesCount());
    }
//
//    @GetMapping("/{id}/sub_categories/count")
//    public ResponseEntity<Long> getSubCategoryCountByCategoryId(@PathVariable Long id) {
//        Long count = categoryService.getSubCategoryCountByCategoryId(id);
//        return ResponseEntity.ok(count);
//    }

    @GetMapping("/{id}/sub_categories/count")
    public ResponseEntity<Map<String, Long>> getSubCategoryCountByCategoryId(@PathVariable Long id) {
        Long count = categoryService.getSubCategoryCountByCategoryId(id);
        Map<String, Long> response = new HashMap<>();
        response.put("total", count);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/{id}/3d_objects/count")
    public ResponseEntity<Map<String, Long>> getThreeDObjectCountByCategoryId(@PathVariable Long id) {
        Long count = categoryService.getThreeDObjectCountByCategoryId(id);
        Map<String, Long> response = new HashMap<>();
        response.put("total", count);
        return ResponseEntity.ok(response);
    }

}