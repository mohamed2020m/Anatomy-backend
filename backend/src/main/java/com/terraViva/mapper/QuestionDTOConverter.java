package com.terraViva.mapper;

import com.terraViva.dto.MCQQuestionDTO;
import com.terraViva.models.MCQQuestion;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Component;

@Component
public class QuestionDTOConverter {

    private final ModelMapper modelMapper;

    public QuestionDTOConverter() {
        this.modelMapper = new ModelMapper();
    }

    public MCQQuestion mapToMCQQuestion(MCQQuestionDTO questionDTO) {
        return modelMapper.map(questionDTO, MCQQuestion.class);
    }

    public MCQQuestionDTO mapToQuestionDTO(MCQQuestion mcqQuestion) {
        return modelMapper.map(mcqQuestion, MCQQuestionDTO.class);
    }
}
