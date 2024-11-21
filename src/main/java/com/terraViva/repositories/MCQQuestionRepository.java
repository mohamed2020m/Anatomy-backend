package com.terraViva.repositories;

import com.terraViva.models.MCQQuestion;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface MCQQuestionRepository extends JpaRepository<MCQQuestion, Long> {
    List<MCQQuestion> findByQuizId(Long quizId);
}
