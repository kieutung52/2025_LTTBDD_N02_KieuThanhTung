package com.service.backend.DTO.structurejson;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.service.backend.DTO.enumdata.VocabularyType;

import lombok.Data;

@Data
public class VocabularyDetailData {

    @JsonProperty("type")
    private VocabularyType type;

    @JsonProperty("meaning")
    private String meaning;

    @JsonProperty("explanation")
    private String explanation;

    @JsonProperty("example")
    private String example;
}
