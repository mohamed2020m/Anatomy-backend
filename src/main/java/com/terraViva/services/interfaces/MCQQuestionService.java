package com.terraViva.services.interfaces;

import com.terraViva.dto.MCQQuestionDTO;
import com.terraViva.models.MCQQuestion;
import java.util.List;
import java.util.Map;

public interface MCQQuestionService {
    List<MCQQuestion> getAllQuestions();
    MCQQuestion getQuestionById(Long id);
    MCQQuestion createQuestion(MCQQuestion mcqQuestion);
//    MCQQuestion updateQuestion(Long id, MCQQuestion mcqQuestion);
    MCQQuestion updateQuestion(Long id, MCQQuestionDTO questionDTO);
    void deleteQuestion(Long id);
    List<MCQQuestion> getQuestionsByQuiz(Long quizId);
//
//    MCQQuestion addOptions(Long questionId, Map<String, String> newOptions);
//    MCQQuestion updateOption(Long questionId, String key, String newValue);
//    MCQQuestion deleteOption(Long questionId, String key);

}
