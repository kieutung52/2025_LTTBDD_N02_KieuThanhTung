package com.service.backend.DTO.DataTransform.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BooleanResponse {
    private boolean result;
    private String message;
}
