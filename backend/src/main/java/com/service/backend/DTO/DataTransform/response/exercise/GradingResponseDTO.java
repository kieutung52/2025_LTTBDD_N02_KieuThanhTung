package com.service.backend.DTO.DataTransform.response.exercise;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GradingResponseDTO {
    private Long exerciseDailyId;
    private int totalQuestions;
    private int correctAnswers;
    private double score;
    private List<QuestionResultDTO> results;
    
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class QuestionResultDTO {
        private Long questionId;
        private String question;
        private String userAnswer;
        private String correctAnswer;
        private boolean isCorrect;
        private String explanation;
        private String questionType;
        private List<String> options;
    }
}