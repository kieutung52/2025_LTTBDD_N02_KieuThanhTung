package com.service.backend.DTO.DataTransform.response.exercise;

import com.service.backend.DTO.enumdata.ExerciseType; 
import com.service.backend.models.ExerciseDaily;
import com.service.backend.models.ExerciseDetails;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ExerciseDailyResponseDTO {
    private Long ID;
    private int totalQuestions;
    private int correctAnswers;
    private ExerciseType exerciseType;
    private LocalDateTime date;
    private String analytics;
    private List<ExerciseDetailResponseDTO> details;

    public ExerciseDailyResponseDTO(ExerciseDaily entity) {
        this.ID = entity.getID();
        this.totalQuestions = entity.getTotalQuestions(); 
        this.correctAnswers = entity.getCorrectAnswers(); 
        this.exerciseType = entity.getExerciseType(); 
        this.date = entity.getDate(); 
        this.analytics = entity.getAnalytics(); 
    }

    public ExerciseDailyResponseDTO(ExerciseDaily entity, List<ExerciseDetails> detailEntities) {
        this(entity); 
        
        if (detailEntities != null) {
            this.details = detailEntities.stream()
                            .map(ExerciseDetailResponseDTO::new)
                            .collect(Collectors.toList());
        }
    }
}