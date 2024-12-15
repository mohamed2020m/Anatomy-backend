package com.terraViva.mapper;

import com.terraViva.dto.StudentScoresDTO;
import com.terraViva.models.Quiz;
import com.terraViva.models.Student;
import com.terraViva.models.StudentScores;
import com.terraViva.repositories.QuizRepository;
import com.terraViva.repositories.StudentRepository;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class StudentScoresDTOConverter {

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private QuizRepository quizRepository;

    public StudentScores toEntity(StudentScoresDTO scoresDTO) {
        StudentScores studentScores = new StudentScores();

        // Convert studentId to Student
        Student student = studentRepository.findById(scoresDTO.getStudentId())
                .orElseThrow(() -> new IllegalArgumentException("Student not found for id: " + scoresDTO.getStudentId()));
        studentScores.setStudent(student);

        // Convert quizId to Quiz
        Quiz quiz = quizRepository.findById(scoresDTO.getQuizId())
                .orElseThrow(() -> new IllegalArgumentException("Quiz not found for id: " + scoresDTO.getQuizId()));
        studentScores.setQuiz(quiz);

        studentScores.setScore(scoresDTO.getScore());

        return studentScores;
    }

    public StudentScoresDTO toDto(StudentScores studentScores) {
        return StudentScoresDTO.builder()
                .studentId(studentScores.getStudent().getId())
                .quizId(studentScores.getQuiz().getId())
                .score(studentScores.getScore())
                .build();
    }
}
