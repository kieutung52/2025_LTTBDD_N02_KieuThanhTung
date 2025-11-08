package com.service.backend.DTO.DataTransform.request.learning;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class WordProgressDTO {
    private int dictionaryPersonalId;
    private boolean wasCorrect;
}
