// CategoryService.java
package com.med3dexplorer.services;

import com.med3dexplorer.models.Category;
import com.med3dexplorer.repositories.CategoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.function.Consumer;

@Service
public class CategoryService {

    @Autowired
    private CategoryRepository categoryRepository;

    public List<Category> getAllCategories() {
        return new ArrayList<>(categoryRepository.findAll());
    }

    public Category getCategoryById(Long id) {
        return categoryRepository.findById(id)
                .orElse(null);
    }

    public Category createCategory(Category category) {
        category.setCreatedAt(LocalDateTime.now());
        return categoryRepository.save(category);
    }

    public void deleteCategory(Long id) {
        categoryRepository.deleteById(id);
    }

    // CategoryService.java
    public Category updateCategory(Long id, Category category) {
        return categoryRepository.findById(id).map(existingCategory -> {
            updateIfNotNull(existingCategory::setName, category.getName());
            updateIfNotNull(existingCategory::setDescription, category.getDescription());
            updateIfNotNull(existingCategory::setImage, category.getImage());
            updateIfNotNull(existingCategory::setParentCategory, category.getParentCategory());
            updateIfNotNull(existingCategory::setSubCategories, category.getSubCategories());
            updateIfNotNull(existingCategory::setThreeDObjects, category.getThreeDObjects());
            return categoryRepository.save(existingCategory);
        }).orElse(null);
    }

    private <T> void updateIfNotNull(Consumer<T> setter, T value) {
        if (value != null) {
            setter.accept(value);
        }
    }
}