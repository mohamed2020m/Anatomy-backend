package com.terraViva.dto;

import lombok.Data;

import java.util.Map;

@Data
public class MCQQuestionDTO {
    private String questionText;
    private Map<String, String> options;
    private String correctAnswer;
    private String explanation;
    private Long quizId;
}
