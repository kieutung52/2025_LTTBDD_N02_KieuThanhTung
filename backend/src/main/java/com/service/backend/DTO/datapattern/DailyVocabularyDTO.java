package com.service.backend.DTO.datapattern;

import java.util.ArrayList;
import java.util.List;

import com.service.backend.models.VocabularyDetails;

import lombok.Data;

@Data
public class DailyVocabularyDTO {
    private Long dictionaryPersonalId; // KieuTung.id (bản ghi cá nhân)
    private Long dictionaryId;         // Dictionary.id (từ chung)
    private String vocabulary;
    private List<VocabularyDetails> details;
    private String transcriptionUs;
    
    // Constructor để JPA có thể tạo đối tượng này trực tiếp từ query
    public DailyVocabularyDTO(Long dictionaryPersonalId, Long dictionaryId, String vocabulary, String transcriptionUs) {
        this.dictionaryPersonalId = dictionaryPersonalId;
        this.dictionaryId = dictionaryId;
        this.vocabulary = vocabulary;
        this.details = new ArrayList<>();
        this.transcriptionUs = transcriptionUs;
    }
}