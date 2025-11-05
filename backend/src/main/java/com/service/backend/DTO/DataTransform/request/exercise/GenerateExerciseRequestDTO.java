package com.service.backend.DTO.DataTransform.request.exercise;

import lombok.Data;
import java.util.List;

@Data
public class GenerateExerciseRequestDTO {
    private List<Long> dictionaryIds;
}