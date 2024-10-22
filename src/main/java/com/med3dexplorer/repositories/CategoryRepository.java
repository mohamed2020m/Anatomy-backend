package com.med3dexplorer.repositories;

import com.med3dexplorer.models.Category;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CategoryRepository extends JpaRepository<Category, Long> {}
