package com.med3dexplorer.services.interfaces;

import com.med3dexplorer.dto.CategoryDTO;
import com.med3dexplorer.exceptions.CategoryNotFoundException;

import java.util.List;

public interface CategoryService {
    CategoryDTO saveCategory(CategoryDTO categoryDTO);

    CategoryDTO getCategoryById(Long categoryId) throws CategoryNotFoundException;

    List<CategoryDTO> getSubCategoryByCategoryId(Long categoryId) throws CategoryNotFoundException;

    List<CategoryDTO> getAllCategories();

    CategoryDTO updateCategory(CategoryDTO categoryDTO)throws CategoryNotFoundException;

    void deleteCategory(Long categoryId) throws CategoryNotFoundException;

    Long getCategoriesCount();

    List<CategoryDTO> getMainCategories();

    Long getMainCategoriesCount();
}
