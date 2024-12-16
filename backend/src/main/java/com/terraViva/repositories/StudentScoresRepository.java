package com.terraViva.repositories;

import com.terraViva.models.StudentScores;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface StudentScoresRepository extends JpaRepository<StudentScores, Long> {
    List<StudentScores> findByStudentId(Long studentId);
    List<StudentScores> findByQuizId(Long quizId);

    Optional<StudentScores> findByStudentIdAndQuizId(Long studentId, Long quizId);

}
