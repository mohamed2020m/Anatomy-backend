package com.terraViva.repositories;

import com.terraViva.models.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CategoryRepository extends JpaRepository<Category, Long> {
    List<Category> findByParentCategoryId(Long parentId);
    Optional<Category> findByName(String name);
    List<Category> findByParentCategoryIdIsNull();

    @Query("SELECT COUNT(c) FROM Category c WHERE c.parentCategory IS NULL")
    Long countMainCategories();
}
