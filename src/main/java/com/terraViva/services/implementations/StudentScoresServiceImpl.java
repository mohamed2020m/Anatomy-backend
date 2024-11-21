package com.terraViva.services.implementations;

import com.terraViva.repositories.StudentScoresRepository;
import com.terraViva.services.interfaces.StudentScoresService;
import org.springframework.stereotype.Service;
import com.terraViva.models.StudentScores;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

@Service
public class StudentScoresServiceImpl implements StudentScoresService {

    @Autowired
    private StudentScoresRepository scoresRepository;

    public StudentScores saveScore(StudentScores score) {
        return scoresRepository.save(score);
    }

    public StudentScores getScoreById(Long id) {
        return scoresRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Score not found with ID: " + id));
    }

    public List<StudentScores> getScoresByStudentId(Long studentId) {
        return scoresRepository.findByStudentId(studentId);
    }

    public List<StudentScores> getScoresByQuizId(Long quizId) {
        return scoresRepository.findByQuizId(quizId);
    }

    public void deleteScore(Long id) {
        if (!scoresRepository.existsById(id)) {
            throw new RuntimeException("Score not found with ID: " + id);
        }
        scoresRepository.deleteById(id);
    }
}

