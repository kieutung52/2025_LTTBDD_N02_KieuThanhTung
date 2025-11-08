package com.service.backend.DTO._mapper;

import org.mapstruct.Mapper;

import com.service.backend.DTO.DataTransform.response.dictionary.VocabularyDetailDTO;
import com.service.backend.models.VocabularyDetails;

@Mapper(componentModel = "spring")
public interface VocabularyDetailsMapper {
    VocabularyDetailDTO toVocabularyDetailDTO(VocabularyDetails vocaDetail);
}