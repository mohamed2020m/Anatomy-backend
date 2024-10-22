package com.med3dexplorer.dto;


import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;

// I was planning to use this dto, for now I didn't maybe later :)
@Data
public class CategoryDTO {
    private Long id;
    private String name;
    private String description;
    private String image;
    private LocalDateTime createdAt;
    private Long parentCategoryId;
    private List<Long> subCategoryIds;
    private List<Long> threeDObjectIds;
}