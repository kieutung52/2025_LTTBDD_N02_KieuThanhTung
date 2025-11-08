package com.service.backend.DTO.DataTransform.response.dictionary;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class VocabularyForGenerateExercise {
    private String vocabulary;
    private String meaning;
}
