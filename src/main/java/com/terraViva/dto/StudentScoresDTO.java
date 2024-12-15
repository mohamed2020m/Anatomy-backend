package com.terraViva.dto;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Builder
@Data
@NoArgsConstructor
@AllArgsConstructor
public class StudentScoresDTO {
    //private Long id;
    private Long studentId;
    private Long quizId;
    private double score;
}
