package com.service.backend.DTO.DataTransform.response.dictionary;

import com.service.backend.DTO.enumdata.VocabularyLevel;
import com.service.backend.models.Dictionary;

import lombok.Data;

@Data
public class DictionaryDTO {
    private Long id;
    private String vocabulary;
    private VocabularyLevel level;
    private String transcriptionUk;
    private String transcriptionUs;
    private String audioUrlUk;
    private String audioUrlUs;

    public DictionaryDTO(Dictionary entity) {
        this.id = entity.getId();
        this.vocabulary = entity.getVocabulary();
        this.level = entity.getLevel();
        this.transcriptionUk = entity.getTranscriptionUk();
        this.transcriptionUs = entity.getTranscriptionUs();
        this.audioUrlUk = entity.getAudioUrlUk();
        this.audioUrlUs = entity.getAudioUrlUs();
    }
}
