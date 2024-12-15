package com.terraViva.services.implementations;

import com.terraViva.dto.StudentScoresDTO;
import com.terraViva.mapper.StudentScoresDTOConverter;
import com.terraViva.repositories.StudentScoresRepository;
import com.terraViva.services.interfaces.StudentScoresService;
import org.springframework.stereotype.Service;
import com.terraViva.models.StudentScores;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class StudentScoresServiceImpl implements StudentScoresService {

    @Autowired
    private StudentScoresRepository scoresRepository;

    @Autowired
    private StudentScoresDTOConverter dtoConverter;

    public StudentScoresDTO saveScore(StudentScoresDTO score) {
        StudentScores studentScore = dtoConverter.toEntity(score);

        Long studentId = studentScore.getStudent().getId();
        Long quizId = studentScore.getQuiz().getId();

        // Find the existing score for the same student and quiz
        Optional<StudentScores> existingScoreOpt = scoresRepository.findByStudentIdAndQuizId(studentId, quizId);

        if (existingScoreOpt.isPresent()) {
            // Overwrite the existing score
            StudentScores existingScore = existingScoreOpt.get();
            existingScore.setScore(score.getScore());
            scoresRepository.save(existingScore);
            return dtoConverter.toDto(existingScore);
        } else {
            // Save the new score
            scoresRepository.save(studentScore);
            return score;
        }
    }


    public StudentScores getScoreById(Long id) {
        return scoresRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Score not found with ID: " + id));
    }

    public List<StudentScoresDTO> getScoresByStudentId(Long studentId) {
        List<StudentScores> studentScores = scoresRepository.findByStudentId(studentId);
        return studentScores.stream().map(studentScore -> dtoConverter.toDto(studentScore)).collect(Collectors.toList());
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

    @Override
    public void deleteScoreByQuizIdAndStudentId(Long quizId, Long studentId) {
        // Find the existing score for the same student and quiz
        Optional<StudentScores> existingScoreOpt = scoresRepository.findByStudentIdAndQuizId(studentId, quizId);

        if (existingScoreOpt.isPresent()) {
            // Overwrite the existing score
            StudentScores existingScore = existingScoreOpt.get();
            scoresRepository.delete(existingScore);
        } else {
            throw new RuntimeException("Score not found with ID!");
        }
    }

    @Override
    public List<StudentScoresDTO> getScoreOfAllQuizzes() {
        List<StudentScores> studentScores = scoresRepository.findAll();
        return studentScores
                .stream()
                .map(studentScore ->
                        dtoConverter.toDto(studentScore))
                .collect(Collectors.toList());
    }
}

