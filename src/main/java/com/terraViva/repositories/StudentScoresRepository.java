package com.terraViva.repositories;

import com.terraViva.models.StudentScores;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface StudentScoresRepository extends JpaRepository<StudentScores, Long> {
    List<StudentScores> findByStudentId(Long studentId);
    List<StudentScores> findByQuizId(Long quizId);
}
