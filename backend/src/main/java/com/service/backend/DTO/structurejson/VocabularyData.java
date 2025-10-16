package com.service.backend.DTO.structurejson;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.service.backend.DTO.enumdata.VocabularyLevel;

import lombok.Data;

import java.util.List;

@Data
public class VocabularyData {

    @JsonProperty("vocabulary")
    private String vocabulary;

    @JsonProperty("level")
    private VocabularyLevel level;

    @JsonProperty("transcription_uk")
    private String transcriptionUk;

    @JsonProperty("transcription_us")
    private String transcriptionUs;

    @JsonProperty("details")
    private List<VocabularyDetailData> details;
}

