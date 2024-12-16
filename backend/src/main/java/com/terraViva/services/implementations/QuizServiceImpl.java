package com.terraViva.services.implementations;

import com.terraViva.dto.QuizDTO;
import com.terraViva.models.Category;
import com.terraViva.models.MCQQuestion;
import com.terraViva.models.Quiz;
import com.terraViva.repositories.CategoryRepository;
import com.terraViva.repositories.MCQQuestionRepository;
import com.terraViva.repositories.QuizRepository;
import com.terraViva.services.interfaces.QuizService;
import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class QuizServiceImpl implements QuizService {

    private final QuizRepository quizRepository;
    private final MCQQuestionRepository mcqQuestionRepository;

    @Autowired
    private CategoryRepository categoryRepository;


    public QuizServiceImpl(QuizRepository quizRepository, MCQQuestionRepository mcqQuestionRepository) {
        this.quizRepository = quizRepository;
        this.mcqQuestionRepository = mcqQuestionRepository;
    }

    public List<Quiz> getAllQuizzes() {
        return quizRepository.findAll();
    }

//    public Quiz createQuiz(Quiz quiz) {
//        return quizRepository.save(quiz);
//    }

    @Transactional
    public Quiz createQuiz(Quiz quiz) {
        quiz = quizRepository.save(quiz);

        for (MCQQuestion question : quiz.getQuestions()) {
            question.setQuiz(quiz);
        }
        mcqQuestionRepository.saveAll(quiz.getQuestions());

        return quiz;
    }

    public Quiz updateQuiz(Long id, QuizDTO quizDTO) {
        Quiz existingQuiz = quizRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Quiz not found"));

        if (quizDTO.getTitle() != null) {
            existingQuiz.setTitle(quizDTO.getTitle());
        }

        if (quizDTO.getDescription() != null) {
            existingQuiz.setDescription(quizDTO.getDescription());
        }

        if (quizDTO.getSubCategoryId() != null) {
            Category subCategory = categoryRepository.findById(quizDTO.getSubCategoryId())
                    .orElseThrow(() -> new EntityNotFoundException("SubCategory not found"));
            existingQuiz.setSubCategory(subCategory);
        }

        return quizRepository.save(existingQuiz);
    }

    public Quiz getQuizById(Long id) {
        return quizRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Quiz not found"));
    }

    public void deleteQuiz(Long id) {
        quizRepository.deleteById(id);
    }
}

