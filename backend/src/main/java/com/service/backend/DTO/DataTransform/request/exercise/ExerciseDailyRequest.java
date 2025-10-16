package com.service.backend.DTO.DataTransform.request.exercise;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ExerciseDailyRequest {
    private String userID;
    private int totalQuestions;
    private int correctAnswers;
    private String exerciseType;
    private String analytics;
}
