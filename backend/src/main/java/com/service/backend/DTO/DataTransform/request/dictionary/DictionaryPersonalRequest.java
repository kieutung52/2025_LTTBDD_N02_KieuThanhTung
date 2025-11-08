package com.service.backend.DTO.DataTransform.request.dictionary;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class DictionaryPersonalRequest {
    private String userId;
    private Long dictionaryId;
}
