package com.service.backend.DTO.datapattern;

import java.util.ArrayList;
import java.util.List;

import com.service.backend.models.VocabularyDetails;

import lombok.Data;

@Data
public class DailyVocabularyDTO {
    private Long dictionaryPersonalId;
    private Long dictionaryId;
    private String vocabulary;
    private List<VocabularyDetails> details;
    private String transcriptionUs;
    
    public DailyVocabularyDTO(Long dictionaryPersonalId, Long dictionaryId, String vocabulary, String transcriptionUs) {
        this.dictionaryPersonalId = dictionaryPersonalId;
        this.dictionaryId = dictionaryId;
        this.vocabulary = vocabulary;
        this.details = new ArrayList<>();
        this.transcriptionUs = transcriptionUs;
    }
}