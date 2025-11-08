package com.service.backend.DTO.DataTransform.response.dictionary;

import com.service.backend.DTO.enumdata.VocabularyType;
import com.service.backend.models.VocabularyDetails;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class VocabularyDetailDTO {
    private VocabularyType vocabType;
    private String meaning;
    private String explanation;
    private String exampleSentence;

    public VocabularyDetailDTO(VocabularyDetails entity) {
        this.vocabType = entity.getVocabType();
        this.meaning = entity.getMeaning();
        this.explanation = entity.getExplanation();
        this.exampleSentence = entity.getExampleSentence();
    }
}
