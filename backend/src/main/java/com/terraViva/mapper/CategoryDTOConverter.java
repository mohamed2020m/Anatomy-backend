package com.terraViva.mapper;

import com.terraViva.dto.CategoryDTO;
import com.terraViva.models.Category;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class CategoryDTOConverter {


    @Autowired
    private ModelMapper modelMapper;

    public Category toEntity(CategoryDTO CategoryDTO) {
        Category Category = modelMapper.map(CategoryDTO, Category.class);
        return Category;
    }

    public  CategoryDTO toDto(Category Category) {
        CategoryDTO CategoryDTO =modelMapper.map(Category,CategoryDTO.class);
        return CategoryDTO;
    }

}
