package com.terraViva.mapper;

import com.terraViva.dto.MCQQuestionDTO;
import com.terraViva.models.MCQQuestion;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;


@Mapper(componentModel = "spring")
public interface QuestionMapper {
    void updateFromDto(MCQQuestionDTO dto, @MappingTarget MCQQuestion entity);
    MCQQuestionDTO toDTO(MCQQuestion entity);
}
