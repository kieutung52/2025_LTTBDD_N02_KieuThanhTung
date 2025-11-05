package com.service.backend.DTO.DataTransform.request.learning;

import java.util.List;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class UpdateProgressRequest {
    private List<WordProgressDTO> progressList;
}
