package com.service.backend.DTO.DataTransform.response.dictionary;

import java.util.List;

import com.service.backend.DTO.enumdata.VocabularyLevel;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class SearchWordResponseDTO {
    private String vocabulary;
    private VocabularyLevel level;
    private String transcriptionUk;
    private String transcriptionUs;
    private List<VocabularyDetailDTO> details;
}
