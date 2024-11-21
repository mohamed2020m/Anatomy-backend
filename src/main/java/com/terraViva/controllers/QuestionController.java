package com.terraViva.controllers;

import com.terraViva.dto.MCQQuestionDTO;
import com.terraViva.mapper.QuestionDTOConverter;
import com.terraViva.mapper.QuestionMapper;
import com.terraViva.models.MCQQuestion;
import com.terraViva.models.Quiz;
import com.terraViva.services.interfaces.MCQQuestionService;
import com.terraViva.services.interfaces.QuizService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/questions")
public class QuestionController {

    private final MCQQuestionService mcqQuestionService;
//    private final QuestionDTOConverter questionDTOConverter;

    @Autowired
    private QuestionMapper questionMapper;

    private final QuizService quizService;

    public QuestionController(MCQQuestionService mcqQuestionService, QuestionDTOConverter questionDTOConverter, QuizService quizService) {
        this.mcqQuestionService = mcqQuestionService;
//        this.questionDTOConverter = questionDTOConverter;
        this.quizService = quizService;
    }

    @GetMapping
    public ResponseEntity<List<MCQQuestion>> getAllQuestions() {
        List<MCQQuestion> questions = mcqQuestionService.getAllQuestions();
        return ResponseEntity.ok(questions);
    }

    @GetMapping("/{id}")
    public ResponseEntity<MCQQuestion> getQuestionById(@PathVariable Long id) {
        MCQQuestion question = mcqQuestionService.getQuestionById(id);
        return ResponseEntity.ok(question);
    }

//    @PostMapping
//    public ResponseEntity<MCQQuestion> createQuestion(@RequestBody MCQQuestion mcqQuestion) {
//        MCQQuestion createdQuestion = mcqQuestionService.createQuestion(mcqQuestion);
//        return ResponseEntity.ok(createdQuestion);
//    }

    @PostMapping
    public ResponseEntity<MCQQuestion> createQuestion(@RequestBody MCQQuestionDTO mcqQuestionDTO) {
        Quiz quiz = quizService.getQuizById(mcqQuestionDTO.getQuizId());
        if (quiz == null) {
            return ResponseEntity.badRequest().body(null);
        }

        // Create the question entity
        MCQQuestion mcqQuestion = new MCQQuestion();
        mcqQuestion.setQuestionText(mcqQuestionDTO.getQuestionText());
        mcqQuestion.setOptions(mcqQuestionDTO.getOptions());
        mcqQuestion.setCorrectAnswer(mcqQuestionDTO.getCorrectAnswer());
        mcqQuestion.setExplanation(mcqQuestionDTO.getExplanation());
        mcqQuestion.setQuiz(quiz);

        // Save the question
        MCQQuestion savedQuestion = mcqQuestionService.createQuestion(mcqQuestion);
        return ResponseEntity.ok(savedQuestion);
    }


    @PatchMapping("/{id}")
    public ResponseEntity<MCQQuestion> updateQuestion(@PathVariable Long id, @RequestBody MCQQuestionDTO questionDTO) {
//        MCQQuestion mcqQuestion = questionDTOConverter.mapToMCQQuestion(questionDTO);
        MCQQuestion updatedQuestion = mcqQuestionService.updateQuestion(id, questionDTO);
//        MCQQuestionDTO updatedQuestionDTO = questionDTOConverter.mapToQuestionDTO(updatedQuestion);
        return ResponseEntity.ok(updatedQuestion);
    }

//    @PatchMapping("/{id}")
//    public ResponseEntity<MCQQuestionDTO> updateQuestion(
//            @PathVariable Long id,
//            @RequestBody MCQQuestionDTO questionDTO) {
//        MCQQuestion updatedQuestion = mcqQuestionService.updateQuestion(id, questionDTO);
//        return ResponseEntity.ok(questionMapper.toDTO(updatedQuestion));
//    }



    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteQuestion(@PathVariable Long id) {
        mcqQuestionService.deleteQuestion(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/quiz/{quizId}")
    public ResponseEntity<List<MCQQuestion>> getQuestionsByQuiz(@PathVariable Long quizId) {
        List<MCQQuestion> questions = mcqQuestionService.getQuestionsByQuiz(quizId);
        return ResponseEntity.ok(questions);
    }
}
