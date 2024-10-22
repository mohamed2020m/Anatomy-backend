package com.med3dexplorer.mapper;

import com.med3dexplorer.dto.CategoryDTO;
import com.med3dexplorer.models.Category;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface CategoryMapper {
    @Mapping(source = "parentCategory.id", target = "parentCategoryId")
    CategoryDTO toDTO(Category category);

    @Mapping(source = "parentCategoryId", target = "parentCategory.id")
    Category toEntity(CategoryDTO categoryDTO);
}