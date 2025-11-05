package com.service.backend.DTO.DataTransform.request.exercise;

import lombok.Data;
import java.util.List;

@Data
public class ExerciseGradingRequest {
    private Long exerciseDailyId;
    private List<GradingQuestion> questions;
    
    @Data
    public static class GradingQuestion {
        private String question;
        private String userAnswer;
        private String trueAnswer;
        private String questionType;
    }
}
