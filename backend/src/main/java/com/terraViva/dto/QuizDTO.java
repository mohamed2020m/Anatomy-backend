package com.terraViva.dto;

import lombok.Data;

import java.util.List;

@Data
public class QuizDTO {
    private String title;
    private String description;
    private Long subCategoryId;
}
