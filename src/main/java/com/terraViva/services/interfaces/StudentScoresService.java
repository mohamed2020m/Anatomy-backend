package com.terraViva.services.interfaces;

import com.terraViva.dto.StudentScoresDTO;
import com.terraViva.dto.UpdateUserInfoRequestDTO;
import com.terraViva.models.StudentScores;

import java.util.List;

public interface StudentScoresService {
    StudentScoresDTO saveScore(StudentScoresDTO score);
    StudentScores getScoreById(Long id);
    List<StudentScoresDTO> getScoresByStudentId(Long studentId);
    List<StudentScores> getScoresByQuizId(Long quizId);
    void deleteScore(Long id);

    void deleteScoreByQuizIdAndStudentId(Long quizId, Long studentId);

    List<StudentScoresDTO> getScoreOfAllQuizzes();
}
