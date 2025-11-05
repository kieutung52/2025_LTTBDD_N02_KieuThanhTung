package com.service.backend.DTO.DataTransform.request.exercise;

import lombok.Data;
import java.util.List;

@Data
public class GradingRequestDTO {
    private Long exerciseDailyId;
    private List<QuestionAnswerDTO> answers;
    
    @Data
    public static class QuestionAnswerDTO {
        private Long questionId;
        private String userAnswer;
    }
}