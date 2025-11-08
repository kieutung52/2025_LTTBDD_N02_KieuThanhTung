package com.service.backend.DTO.DataTransform.response.exercise;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GradingResult {
    private String question;
    private String userAnswer;
    private String trueAnswer;
    private String aiExplain;
    private boolean isCorrect;
}