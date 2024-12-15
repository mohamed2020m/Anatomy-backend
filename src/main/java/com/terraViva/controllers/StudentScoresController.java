package com.terraViva.controllers;

import com.terraViva.dto.StudentScoresDTO;
import com.terraViva.models.StudentScores;
import com.terraViva.services.interfaces.StudentScoresService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/scores")
public class StudentScoresController {

    @Autowired
    private StudentScoresService scoresService;

//    @PostMapping
//    public ResponseEntity<StudentScores> saveScore(@RequestBody StudentScores score) {
//        StudentScores savedScore = scoresService.saveScore(score);
//        return ResponseEntity.ok(savedScore);
//    }

    @PostMapping
    public ResponseEntity<StudentScoresDTO> saveScore(@RequestBody StudentScoresDTO score) {
        StudentScoresDTO savedScore = scoresService.saveScore(score);
        return ResponseEntity.ok(savedScore);
    }

    @GetMapping("/{id}")
    public ResponseEntity<StudentScores> getScoreById(@PathVariable Long id) {
        StudentScores score = scoresService.getScoreById(id);
        return ResponseEntity.ok(score);
    }

    @GetMapping("/student/{studentId}")
    public ResponseEntity<List<StudentScoresDTO>> getScoresByStudentId(@PathVariable Long studentId) {
        List<StudentScoresDTO> scores = scoresService.getScoresByStudentId(studentId);
        return ResponseEntity.ok(scores);
    }

    @GetMapping("/quiz/{quizId}")
    public ResponseEntity<List<StudentScores>> getScoresByQuizId(@PathVariable Long quizId) {
        List<StudentScores> scores = scoresService.getScoresByQuizId(quizId);
        return ResponseEntity.ok(scores);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteScore(@PathVariable Long id) {
        scoresService.deleteScore(id);
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/quiz/{quizId}/student/{studentId}")
    public ResponseEntity<Void> deleteScoreByQuizIdAndStudentId(@PathVariable Long quizId, @PathVariable Long studentId) {
        scoresService.deleteScoreByQuizIdAndStudentId(quizId, studentId);
        return ResponseEntity.noContent().build(); // Success: HTTP 204
    }

    @GetMapping()
    public ResponseEntity<List<StudentScoresDTO>> getScoreOfAllQuizzes() {
        List<StudentScoresDTO> scoreOfAllQuizzes = scoresService.getScoreOfAllQuizzes();
        return ResponseEntity.ok(scoreOfAllQuizzes);
    }
}
