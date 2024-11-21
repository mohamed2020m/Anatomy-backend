package com.terraViva.controllers;

import com.terraViva.dto.QuizDTO;
import com.terraViva.mapper.QuizDTOConverter;
import com.terraViva.models.Category;
import com.terraViva.models.MCQQuestion;
import com.terraViva.models.Quiz;
import com.terraViva.repositories.CategoryRepository;
import com.terraViva.services.interfaces.QuizService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/quizzes")
public class QuizController {
    private final QuizService quizService;

    public QuizController(QuizService quizService) {
        this.quizService = quizService;
    }

    @GetMapping
    public ResponseEntity<List<Quiz>> getAllQuizzes() {
        return ResponseEntity.ok(quizService.getAllQuizzes());
    }

    @PostMapping
    public ResponseEntity<Quiz> createQuiz(@RequestBody Quiz quiz) {
        for (MCQQuestion question : quiz.getQuestions()) {
            question.setQuiz(quiz);
        }

        Quiz createdQuiz = quizService.createQuiz(quiz);
        return ResponseEntity.ok(createdQuiz);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Quiz> getQuizById(@PathVariable Long id) {
        return ResponseEntity.ok(quizService.getQuizById(id));
    }


//    @PutMapping("/{id}")
//    public ResponseEntity<Quiz> updateQuiz(@PathVariable Long id, @RequestBody Quiz updatedQuiz) {
//        Quiz existingQuiz = quizService.getQuizById(id);
//
//        // Update the fields of the existing quiz
//        existingQuiz.setTitle(updatedQuiz.getTitle());
//        existingQuiz.setDescription(updatedQuiz.getDescription());
//        existingQuiz.setSubCategory(updatedQuiz.getSubCategory());
//
//        // Update the questions associated with the quiz (ensure the quiz is set on the questions)
//        for (MCQQuestion question : updatedQuiz.getQuestions()) {
//            question.setQuiz(existingQuiz);
//        }
//
//        // Save the updated quiz
//        Quiz savedQuiz = quizService.createQuiz(existingQuiz);
//        return ResponseEntity.ok(savedQuiz);
//    }

//    @PatchMapping("/{id}")
//    public ResponseEntity<Quiz> patchQuiz(@PathVariable Long id, @RequestBody QuizDTO quizDTO) {
//        // Retrieve the existing quiz from the database
//        Quiz existingQuiz = quizService.getQuizById(id);
//
//        // Fetch the Category entity using subCategoryId from the DTO
//        if (quizDTO.getSubCategoryId() == null) {
//            throw new IllegalArgumentException("SubCategory ID cannot be null.");
//        }
//        Category subCategory = categoryRepository.findById(quizDTO.getSubCategoryId())
//                .orElseThrow(() -> new RuntimeException("SubCategory not found"));
//
//        // Use ModelMapper to map DTO to the entity (excluding subCategory)
//        Quiz updatedQuiz = quizDTOConverter.mapToQuiz(quizDTO);
//
//        // Copy the mapped values from DTO to the existing entity (partial update)
//        existingQuiz.setTitle(updatedQuiz.getTitle());
//        existingQuiz.setDescription(updatedQuiz.getDescription());
//        existingQuiz.setSubCategory(subCategory);
//
//        // Save the updated quiz
//        Quiz savedQuiz = quizService.createQuiz(existingQuiz);
//        return ResponseEntity.ok(savedQuiz);
//    }

    @PatchMapping("/{id}")
    public ResponseEntity<Quiz> updateQuiz(@PathVariable Long id, @RequestBody QuizDTO quizDTO) {
        Quiz updatedQuiz = quizService.updateQuiz(id, quizDTO);
        return ResponseEntity.ok(updatedQuiz);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteQuiz(@PathVariable Long id) {
        quizService.deleteQuiz(id);
        return ResponseEntity.noContent().build();
    }
}
