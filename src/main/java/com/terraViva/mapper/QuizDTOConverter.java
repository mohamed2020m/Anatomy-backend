package com.terraViva.mapper;

import com.terraViva.dto.QuizDTO;
import com.terraViva.models.Quiz;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Component;

@Component
public class QuizDTOConverter {

    private final ModelMapper modelMapper;

    public QuizDTOConverter() {
        this.modelMapper = new ModelMapper();
    }

    public Quiz mapToQuiz(QuizDTO quizDTO) {
        return modelMapper.map(quizDTO, Quiz.class);
    }
}

