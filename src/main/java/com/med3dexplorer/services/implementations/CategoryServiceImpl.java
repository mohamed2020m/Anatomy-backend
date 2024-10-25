package com.med3dexplorer.services.implementations;

import com.med3dexplorer.dto.CategoryDTO;
import com.med3dexplorer.exceptions.UserNotFoundException;
import com.med3dexplorer.mapper.CategoryDTOConverter;
import com.med3dexplorer.models.Category;
import com.med3dexplorer.repositories.CategoryRepository;
import com.med3dexplorer.services.interfaces.CategoryService;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class CategoryServiceImpl implements CategoryService {

    private final CategoryDTOConverter categoryDTOConverter;
    private CategoryRepository categoryRepository;


    public CategoryServiceImpl(CategoryRepository categoryRepository, CategoryDTOConverter categoryDTOConverter) {
        this.categoryDTOConverter = categoryDTOConverter;
        this.categoryRepository = categoryRepository;
    }


    @Override
    public CategoryDTO saveCategory(CategoryDTO categoryDTO){
        Category category=categoryDTOConverter.toEntity(categoryDTO);
        CategoryDTO savedCategory =categoryDTOConverter.toDto(categoryRepository.save(category));
        return savedCategory;
    }

    @Override
    public CategoryDTO getCategoryById(Long categoryId) throws UserNotFoundException {
        Category category = categoryRepository.findById(categoryId).orElseThrow(() -> new UserNotFoundException("Category not found"));
        CategoryDTO categoryDTO = categoryDTOConverter.toDto(category);
        return categoryDTO;
    }

    @Override
    public List<CategoryDTO> getAllCategories() {
        List<Category> categorys = categoryRepository.findAll();
        List<CategoryDTO> categoryDTOs = categorys.stream().map(category -> categoryDTOConverter.toDto(category)).collect(Collectors.toList());
        return categoryDTOs;
    }

    @Override
    public CategoryDTO updateCategory(CategoryDTO categoryDTO) throws UserNotFoundException {
        Category existingCategory = categoryRepository.findById(categoryDTO.getId())
                .orElseThrow(() -> new UserNotFoundException("Category not found with id: " + categoryDTO.getId()));
        Category updatedCategory = categoryRepository.save(categoryDTOConverter.toEntity(categoryDTO));
        return categoryDTOConverter.toDto(updatedCategory);
    }


    @Override
    public void deleteCategory(Long categoryId) throws UserNotFoundException {
        Category category=categoryRepository.findById(categoryId).orElseThrow(() -> new UserNotFoundException("Category not found"));
        categoryRepository.delete(category);
    }

}