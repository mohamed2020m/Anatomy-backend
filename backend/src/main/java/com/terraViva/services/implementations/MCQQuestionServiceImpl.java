package com.terraViva.services.implementations;

import com.terraViva.dto.MCQQuestionDTO;
import com.terraViva.mapper.QuestionMapper;
import com.terraViva.models.MCQQuestion;
import com.terraViva.repositories.MCQQuestionRepository;
import com.terraViva.services.interfaces.MCQQuestionService;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class MCQQuestionServiceImpl implements MCQQuestionService {

    @Autowired
    private MCQQuestionRepository questionRepository;

    private final MCQQuestionRepository mcqQuestionRepository;

//    @Autowired
//    private QuestionMapper questionMapper;

    public MCQQuestionServiceImpl(MCQQuestionRepository mcqQuestionRepository) {
        this.mcqQuestionRepository = mcqQuestionRepository;
    }

    @Override
    public List<MCQQuestion> getAllQuestions() {
        return mcqQuestionRepository.findAll();
    }

    @Override
    public MCQQuestion getQuestionById(Long id) {
        return mcqQuestionRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Question not found"));
    }

    @Override
    public MCQQuestion createQuestion(MCQQuestion mcqQuestion) {
        return mcqQuestionRepository.save(mcqQuestion);
    }

//    @Override
//    public MCQQuestion updateQuestion(Long id, MCQQuestion mcqQuestion) {
//        if (!mcqQuestionRepository.existsById(id)) {
//            throw new RuntimeException("Question not found");
//        }
//        mcqQuestion.setId(id);
//        return mcqQuestionRepository.save(mcqQuestion);
//    }


//    public MCQQuestion updateQuestion(Long id, MCQQuestionDTO questionDTO) {
//        MCQQuestion existingQuestion = mcqQuestionRepository.findById(id)
//                .orElseThrow(() -> new EntityNotFoundException("Question not found"));
//
//        questionMapper.updateFromDto(questionDTO, existingQuestion);
//        return mcqQuestionRepository.save(existingQuestion);
//    }


    public MCQQuestion updateQuestion(Long id, MCQQuestionDTO questionDTO) {
        MCQQuestion existingQuestion = mcqQuestionRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Question not found"));

        if (questionDTO.getQuestionText() != null) {
            existingQuestion.setQuestionText(questionDTO.getQuestionText());
        }
        if (questionDTO.getOptions() != null) {
            existingQuestion.setOptions(questionDTO.getOptions());
        }
        if (questionDTO.getCorrectAnswer() != null) {
            existingQuestion.setCorrectAnswer(questionDTO.getCorrectAnswer());
        }

        if (questionDTO.getExplanation() != null){
            existingQuestion.setExplanation(questionDTO.getExplanation());
        }

        return mcqQuestionRepository.save(existingQuestion);
    }

    @Override
    public void deleteQuestion(Long id) {
        mcqQuestionRepository.deleteById(id);
    }

    @Override
    public List<MCQQuestion> getQuestionsByQuiz(Long quizId) {
        return mcqQuestionRepository.findByQuizId(quizId);
    }

//    // options
//    public MCQQuestion addOptions(Long questionId, Map<String, String> newOptions) {
//        MCQQuestion question = questionRepository.findById(questionId)
//                .orElseThrow(() -> new EntityNotFoundException("Question not found"));
//        question.getOptions().putAll(newOptions); // Add new options
//        return questionRepository.save(question);
//    }
//
//    // Update an existing option
//    public MCQQuestion updateOption(Long questionId, String key, String newValue) {
//        MCQQuestion question = questionRepository.findById(questionId)
//                .orElseThrow(() -> new EntityNotFoundException("Question not found"));
//        if (!question.getOptions().containsKey(key)) {
//            throw new IllegalArgumentException("Option key not found");
//        }
//        question.getOptions().put(key, newValue); // Update the option
//        return questionRepository.save(question);
//    }
//
//    // Delete an option
//    public MCQQuestion deleteOption(Long questionId, String key) {
//        MCQQuestion question = questionRepository.findById(questionId)
//                .orElseThrow(() -> new EntityNotFoundException("Question not found"));
//        if (!question.getOptions().containsKey(key)) {
//            throw new IllegalArgumentException("Option key not found");
//        }
//        question.getOptions().remove(key); // Remove the option
//        return questionRepository.save(question);
//    }
}
