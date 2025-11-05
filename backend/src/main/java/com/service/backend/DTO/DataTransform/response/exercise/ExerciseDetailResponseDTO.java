package com.service.backend.DTO.DataTransform.response.exercise;

import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.service.backend.models.ExerciseDetails;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ExerciseDetailResponseDTO {
    private Long id;
    private String question;
    private String questionType;
    private List<String> options;
    private String trueAnswer;
    private String userAnswer;
    private boolean isCorrect;
    private String aiExplain;

    public ExerciseDetailResponseDTO(ExerciseDetails entity) {
        this.id = entity.getID();
        this.question = entity.getQuestion();
        this.questionType = entity.getQuestionType();
        this.trueAnswer = entity.getTrueAnswer();
        this.userAnswer = entity.getUserAnswer();
        this.isCorrect = entity.isCorrect();
        this.aiExplain = entity.getAiExplain();
        
        // Sửa lỗi type safety với TypeReference
        if (entity.getOptions() != null && !entity.getOptions().isEmpty()) {
            try {
                ObjectMapper mapper = new ObjectMapper();
                this.options = mapper.readValue(
                    entity.getOptions(), 
                    new TypeReference<List<String>>() {}
                );
            } catch (Exception e) {
                this.options = new ArrayList<String>();
            }
        } else {
            this.options = new ArrayList<String>();
        }
    }
}