package com.terraViva.services.interfaces;

import com.terraViva.dto.QuizDTO;
import com.terraViva.models.Quiz;
import java.util.List;

public interface QuizService {
    List<Quiz> getAllQuizzes();
    Quiz createQuiz(Quiz quiz);
    Quiz updateQuiz(Long id, QuizDTO quizDTO);
    Quiz getQuizById(Long id);
    void deleteQuiz(Long id);
}
