package com.terraViva.controllers;

import com.terraViva.models.StudentScores;
import com.terraViva.services.interfaces.StudentScoresService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/scores")
public class StudentScoresController {

    @Autowired
    private StudentScoresService scoresService;

    @PostMapping
    public ResponseEntity<StudentScores> saveScore(@RequestBody StudentScores score) {
        StudentScores savedScore = scoresService.saveScore(score);
        return ResponseEntity.ok(savedScore);
    }

    @GetMapping("/{id}")
    public ResponseEntity<StudentScores> getScoreById(@PathVariable Long id) {
        StudentScores score = scoresService.getScoreById(id);
        return ResponseEntity.ok(score);
    }

    @GetMapping("/student/{studentId}")
    public ResponseEntity<List<StudentScores>> getScoresByStudentId(@PathVariable Long studentId) {
        List<StudentScores> scores = scoresService.getScoresByStudentId(studentId);
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
}
