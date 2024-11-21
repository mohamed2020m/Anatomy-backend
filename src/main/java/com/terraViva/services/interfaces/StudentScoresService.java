package com.terraViva.services.interfaces;

import com.terraViva.models.StudentScores;

import java.util.List;

public interface StudentScoresService {
    StudentScores saveScore(StudentScores score);
    StudentScores getScoreById(Long id);
    List<StudentScores> getScoresByStudentId(Long studentId);
    List<StudentScores> getScoresByQuizId(Long quizId);
    void deleteScore(Long id);
}
