package com.med3dexplorer.services.implementations;

import com.med3dexplorer.dto.CategoryDTO;
import com.med3dexplorer.exceptions.UserNotFoundException;
import com.med3dexplorer.mapper.CategoryDTOConverter;
import com.med3dexplorer.models.Category;
import com.med3dexplorer.repositories.CategoryRepository;
import com.med3dexplorer.services.interfaces.CategoryService;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
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
    public CategoryDTO saveCategory(CategoryDTO categoryDTO) {

        Category parentCategory = null;
        if (categoryDTO.getParentCategoryId() != null) {
            parentCategory = categoryRepository.findById(categoryDTO.getParentCategoryId())
                    .orElse(null);
        }

        Category category = Category.builder()
                .name(categoryDTO.getName())
                .description(categoryDTO.getDescription())
                .image(categoryDTO.getImage())
                .createdAt(LocalDateTime.now())
                .parentCategory(parentCategory)
                .build();

        CategoryDTO savedCategory = categoryDTOConverter.toDto(categoryRepository.save(category));
        return savedCategory;
    }


    @Override
    public CategoryDTO getCategoryById(Long categoryId) throws UserNotFoundException {
        Category category = categoryRepository.findById(categoryId).orElseThrow(() -> new UserNotFoundException("Category not found"));
        CategoryDTO categoryDTO = categoryDTOConverter.toDto(category);
        return categoryDTO;
    }

    @Override
    public List<CategoryDTO> getSubCategoryByCategoryId(Long categoryId) throws UserNotFoundException {
        Category category = categoryRepository.findById(categoryId)
                .orElseThrow(() -> new UserNotFoundException("Category not found"));
        List<Category> subcategories = categoryRepository.findByParentCategoryId(categoryId);
        return subcategories.stream()
                .map(categoryDTOConverter::toDto)
                .collect(Collectors.toList());
    }

    // getting categories crated by the admin
    @Override
    public List<CategoryDTO> getCategories() {
        List<Category> categories = categoryRepository.findByParentCategoryIdIsNull();
        List<CategoryDTO> categoryDTOs = categories.stream().map(category -> categoryDTOConverter.toDto(category)).collect(Collectors.toList());
        return categoryDTOs;
    }


    @Override
    public List<CategoryDTO> getAllCategories() {
        List<Category> categories = categoryRepository.findAll();
        List<CategoryDTO> categoryDTOs = categories.stream().map(category -> categoryDTOConverter.toDto(category)).collect(Collectors.toList());
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
        Category category = categoryRepository.findById(categoryId).orElseThrow(() -> new UserNotFoundException("Category not found"));
        categoryRepository.delete(category);
    }

    @Override
    public Long getCategoriesCount() {
        return categoryRepository.count();
    }

    @Override
    public List<CategoryDTO> getMainCategories(){
        List<Category> categories = categoryRepository.findByParentCategoryIsNull();
        List<CategoryDTO> categoryDTOs = categories.stream().map(category -> categoryDTOConverter.toDto(category)).collect(Collectors.toList());
        return categoryDTOs;
    }

}