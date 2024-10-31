package com.med3dexplorer.repositories;

import com.med3dexplorer.models.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CategoryRepository extends JpaRepository<Category, Long> {
    List<Category> findByParentCategoryId(Long parentId);
    Optional<Category> findByName(String name);
    List<Category> findByParentCategoryIdIsNull();
}
